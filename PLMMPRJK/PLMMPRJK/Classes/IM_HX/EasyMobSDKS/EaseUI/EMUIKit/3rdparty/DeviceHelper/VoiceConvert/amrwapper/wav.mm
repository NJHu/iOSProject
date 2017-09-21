/* ------------------------------------------------------------------
 * Copyright (C) 2009 Martin Storsjo
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 * -------------------------------------------------------------------
 */

#import <UIKit/UIKit.h>
#include "wav.h"

void WavWriter::writeString(const char *str) {
	fputc(str[0], wav);
	fputc(str[1], wav);
	fputc(str[2], wav);
	fputc(str[3], wav);
}

void WavWriter::writeInt32(int value) {
	fputc((value >>  0) & 0xff, wav);
	fputc((value >>  8) & 0xff, wav);
	fputc((value >> 16) & 0xff, wav);
	fputc((value >> 24) & 0xff, wav);
}

void WavWriter::writeInt16(int value) {
	fputc((value >> 0) & 0xff, wav);
	fputc((value >> 8) & 0xff, wav);
}

void WavWriter::writeHeader(int length) {
    writeString("RIFF");
    writeInt32(4 + 8 + 20 + 8 + length);  //将16改为20
    writeString("WAVE");
    
    writeString("fmt ");
    writeInt32(20);
    
    int bytesPerFrame = bitsPerSample/8*channels;
    int bytesPerSec = bytesPerFrame*sampleRate;
    writeInt16(1);             // Format
    writeInt16(channels);      // Channels
    writeInt32(sampleRate);    // Samplerate
    writeInt32(bytesPerSec);   // Bytes per sec
    writeInt16(bytesPerFrame); // Bytes per frame
    writeInt16(bitsPerSample); // Bits per sample
    
    writeInt32(0);             //这儿需要字节对齐  nExSize
    
    writeString("data");
    writeInt32(length);
}

WavWriter::WavWriter(const char *filename, int sampleRate, int bitsPerSample, int channels) 
{
	
	NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath       = [paths objectAtIndex:0];
	NSString *docFilePath        = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%s", filename]];
	//NSLog(@"documentPath=%@", documentPath);
	
	wav = fopen([docFilePath cStringUsingEncoding:NSASCIIStringEncoding], "wb");
	if (wav == NULL)
		return;
	dataLength = 0;
	this->sampleRate = sampleRate;
	this->bitsPerSample = bitsPerSample;
	this->channels = channels;

	writeHeader(dataLength);
}

WavWriter::~WavWriter() {
	if (wav == NULL)
		return;
	fseek(wav, 0, SEEK_SET);
	writeHeader(dataLength);
	fclose(wav);
}

void WavWriter::writeData(const unsigned char* data, int length) {
	if (wav == NULL)
		return;
	fwrite(data, length, 1, wav);
	dataLength += length;
}

