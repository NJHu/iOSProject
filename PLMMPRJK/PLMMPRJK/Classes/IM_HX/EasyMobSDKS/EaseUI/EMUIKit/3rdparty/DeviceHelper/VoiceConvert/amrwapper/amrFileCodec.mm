//
//  amrFileCodec.cpp
//  amrDemoForiOS
//
//  Created by Tang Xiaoping on 9/27/11.
//  Copyright 2011 test. All rights reserved.
//

#include "amrFileCodec.h"
static int amrEncodeMode[] = {4750, 5150, 5900, 6700, 7400, 7950, 10200, 12200};

// Skip the WAVE header to PCM audio data
static void SkipToPCMAudioData(FILE* fpwave)
{
	EM_RIFFHEADER riff;
	EM_FMTBLOCK fmt;
	EM_XCHUNKHEADER chunk;
	EM_WAVEFORMATX wfx;
	int bDataBlock = 0;
	
	// 1. Read the RIFF header
	fread(&riff, 1, sizeof(EM_RIFFHEADER), fpwave);
	
	// 2.  Read the FMT chunk - if fmt.nFmtSize>16, read the remaining MATX
	fread(&chunk, 1, sizeof(EM_XCHUNKHEADER), fpwave);
	if ( chunk.nChunkSize>16 )
	{
		fread(&wfx, 1, sizeof(EM_WAVEFORMATX), fpwave);
	}
	else
	{
		memcpy(fmt.chFmtID, chunk.chChunkID, 4);
		fmt.nFmtSize = chunk.nChunkSize;
		fread(&fmt.wf, 1, sizeof(EM_WAVEFORMAT), fpwave);
	}
	
	// 3.Switch to the data block
	while(!bDataBlock)
	{
		fread(&chunk, 1, sizeof(EM_XCHUNKHEADER), fpwave);
		if ( !memcmp(chunk.chChunkID, "data", 4) )
		{
			bDataBlock = 1;
			break;
		}
		fseek(fpwave, chunk.nChunkSize, SEEK_CUR);
	}
}

// Read PCM frame from wave file
// Return 0 for error, otherwise return a positive number of the size of frame
static size_t ReadPCMFrame(short speech[], FILE* fpwave, int nChannels, int nBitsPerSample)
{
	size_t nRead = 0;
	int x = 0, y=0;
//	unsigned short ush1=0, ush2=0, ush=0;
	
	// Original PCM autio frame data
	unsigned char  pcmFrame_8b1[PCM_FRAME_SIZE];
	unsigned char  pcmFrame_8b2[PCM_FRAME_SIZE<<1];
	unsigned short pcmFrame_16b1[PCM_FRAME_SIZE];
	unsigned short pcmFrame_16b2[PCM_FRAME_SIZE<<1];
	
	if (nBitsPerSample==8 && nChannels==1)
	{
		nRead = fread(pcmFrame_8b1, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
		for(x=0; x<PCM_FRAME_SIZE; x++)
		{
			speech[x] =(short)((short)pcmFrame_8b1[x] << 7);
		}
	}
	else
		if (nBitsPerSample==8 && nChannels==2)
		{
			nRead = fread(pcmFrame_8b2, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
			for( x=0, y=0; y<PCM_FRAME_SIZE; y++,x+=2 )
			{
				// 1 - Left Channel
				speech[y] =(short)((short)pcmFrame_8b2[x+0] << 7);
				// 2 - Right Channel
				//speech[y] =(short)((short)pcmFrame_8b2[x+1] << 7);
				// 3 - The average of two channels
				//ush1 = (short)pcmFrame_8b2[x+0];
				//ush2 = (short)pcmFrame_8b2[x+1];
				//ush = (ush1 + ush2) >> 1;
				//speech[y] = (short)((short)ush << 7);
			}
		}
		else
			if (nBitsPerSample==16 && nChannels==1)
			{
				nRead = fread(pcmFrame_16b1, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
				for(x=0; x<PCM_FRAME_SIZE; x++)
				{
					speech[x] = (short)pcmFrame_16b1[x+0];
				}
			}
			else
				if (nBitsPerSample==16 && nChannels==2)
				{
					nRead = fread(pcmFrame_16b2, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
					for( x=0, y=0; y<PCM_FRAME_SIZE; y++,x+=2 )
					{
						//speech[y] = (short)pcmFrame_16b2[x+0];
						speech[y] = (short)((int)((int)pcmFrame_16b2[x+0] + (int)pcmFrame_16b2[x+1])) >> 1;
					}
				}
	
	// Return 0 unless read a complete PCM frame
	if (nRead<PCM_FRAME_SIZE*nChannels) return 0;
	
	return nRead;
}

// WAVE audio processing frequency is 8khz
// audio sample processing units = 8000*0.02 = 160 (decided by audio processing frequency)
// audio channels 1 : 160
//        2 : 160*2 = 320
// bps decides the size of sample
// bps = 8 --> 8 bits
//       16 --> 16 bits
int EM_EncodeWAVEFileToAMRFile(const char* pchWAVEFilename, const char* pchAMRFileName, int nChannels, int nBitsPerSample)
{
	FILE* fpwave;
	FILE* fpamr;
	
	/* input speech vector */
	short speech[160];
	
	/* counters */
	int byte_counter, frames = 0;
    size_t bytes = 0;
	
	/* pointer to encoder state structure */
	void *enstate;
	
	/* requested mode */
	enum Mode req_mode = MR122;
	int dtx = 0;
	
	/* bitstream filetype */
	unsigned char amrFrame[MAX_AMR_FRAME_SIZE];
	
	fpwave = fopen(pchWAVEFilename, "rb");
	if (fpwave == NULL)
	{
		return 0;
	}
	
	// Initialize the amr file
	fpamr = fopen(pchAMRFileName, "wb");
	if (fpamr == NULL)
	{
		fclose(fpwave);
		return 0;
	}
	/* write magic number to indicate single channel AMR file storage format */
	bytes = fwrite(AMR_MAGIC_NUMBER, sizeof(char), strlen(AMR_MAGIC_NUMBER), fpamr);
	
	/* skip to pcm audio data*/
	SkipToPCMAudioData(fpwave);
	
	enstate = Encoder_Interface_init(dtx);
	
	while(1)
	{
		// read one pcm frame
		if (!ReadPCMFrame(speech, fpwave, nChannels, nBitsPerSample)) break;
		
		frames++;
		
		/* call encoder */
		byte_counter = Encoder_Interface_Encode(enstate, req_mode, speech, amrFrame, 0);
		
		bytes += byte_counter;
		fwrite(amrFrame, sizeof (unsigned char), byte_counter, fpamr );
	}
	
	Encoder_Interface_exit(enstate);
	
	fclose(fpamr);
	fclose(fpwave);
	
	return frames;
}


#pragma mark - Decode
//decode
static void WriteWAVEFileHeader(FILE* fpwave, int nFrame)
{
	char tag[10] = "";
	
	// 1. RIFF header
	EM_RIFFHEADER riff;
	strcpy(tag, "RIFF");
	memcpy(riff.chRiffID, tag, 4);
	riff.nRiffSize = 4                                     // WAVE
	+ sizeof(EM_XCHUNKHEADER)               // fmt 
	+ sizeof(EM_WAVEFORMATX)           // EM_WAVEFORMATX
	+ sizeof(EM_XCHUNKHEADER)               // DATA
	+ nFrame*160*sizeof(short);    //
	strcpy(tag, "WAVE");
	memcpy(riff.chRiffFormat, tag, 4);
	fwrite(&riff, 1, sizeof(EM_RIFFHEADER), fpwave);
	
	// 2. FMT chunk
	EM_XCHUNKHEADER chunk;
	EM_WAVEFORMATX wfx;
	strcpy(tag, "fmt ");
	memcpy(chunk.chChunkID, tag, 4);
	chunk.nChunkSize = sizeof(EM_WAVEFORMATX);
	fwrite(&chunk, 1, sizeof(EM_XCHUNKHEADER), fpwave);
	memset(&wfx, 0, sizeof(EM_WAVEFORMATX));
	wfx.nFormatTag = 1;
	wfx.nChannels = 1; // Single channel
	wfx.nSamplesPerSec = 8000; // 8khz
	wfx.nAvgBytesPerSec = 16000;
	wfx.nBlockAlign = 2;
	wfx.nBitsPerSample = 16;
	fwrite(&wfx, 1, sizeof(EM_WAVEFORMATX), fpwave);
	
	// 3. Write data chunk
	strcpy(tag, "data");
	memcpy(chunk.chChunkID, tag, 4);
	chunk.nChunkSize = nFrame*160*sizeof(short);
	fwrite(&chunk, 1, sizeof(EM_XCHUNKHEADER), fpwave);
}

static const int myround(const double x)
{
	return((int)(x+0.5));
} 

// Calculate the AMR frame size with the frame header
static int caclAMRFrameSize(unsigned char frameHeader)
{
	int mode;
	int temp1 = 0;
	int temp2 = 0;
	int frameSize;
	
	temp1 = frameHeader;
	
	// Get AMR Encode Mode with the 3 - 6 digit of frame header
	temp1 &= 0x78; // 0111-1000
	temp1 >>= 3;
	
	mode = amrEncodeMode[temp1];
	
	// Calculate the arm auodio framze size
	// Theory: one frame is 20 mili seconds, then one second is 50 frames of audio data
	temp2 = myround((double)(((double)mode / (double)AMR_FRAME_COUNT_PER_SECOND) / (double)8));
	
	frameSize = myround((double)temp2 + 0.5);
	return frameSize;
}

// Read the first AMR frame - (Reference frame)
// return 0 for error and 1 for success
static int ReadAMRFrameFirst(FILE* fpamr, unsigned char frameBuffer[], int* stdFrameSize, unsigned char* stdFrameHeader)
{
	//memset(frameBuffer, 0, sizeof(frameBuffer));
	
	// Read the frame header
	fread(stdFrameHeader, 1, sizeof(unsigned char), fpamr);
	if (feof(fpamr)) return 0;
	
	// Calculate the frame size with frame header
	*stdFrameSize = caclAMRFrameSize(*stdFrameHeader);
	
	// Read the first frame
	frameBuffer[0] = *stdFrameHeader;
	fread(&(frameBuffer[1]), 1, (*stdFrameSize-1)*sizeof(unsigned char), fpamr);
	if (feof(fpamr)) return 0;
	
	return 1;
}

static int ReadAMRFrame(FILE* fpamr, unsigned char frameBuffer[], int stdFrameSize, unsigned char stdFrameHeader)
{
	size_t bytes = 0;
	unsigned char frameHeader; // 帧头
	
	//memset(frameBuffer, 0, sizeof(frameBuffer));
	
	// Read the frame header
	// If it is a bad frame(not a standard frame)，continue for the next byte
	while(1)
	{
		bytes = fread(&frameHeader, 1, sizeof(unsigned char), fpamr);
		if (feof(fpamr)) return 0;
		if (frameHeader == stdFrameHeader) break;
	}
	
	// Audio data for the frame (frame header has beeen read)
    frameBuffer[0] = frameHeader;
	bytes = fread(&(frameBuffer[1]), 1, (stdFrameSize-1)*sizeof(unsigned char), fpamr);
	if (feof(fpamr)) return 0;
	
	return 1;
}

// Decode AMR to WAVE file
int EM_DecodeAMRFileToWAVEFile(const char* pchAMRFileName, const char* pchWAVEFilename)
{

    
	FILE* fpamr = NULL;
	FILE* fpwave = NULL;
	char magic[8];
	void * destate;
	int nFrameCount = 0;
	int stdFrameSize;
	unsigned char stdFrameHeader;
	
	unsigned char amrFrame[MAX_AMR_FRAME_SIZE];
	short pcmFrame[PCM_FRAME_SIZE];
	
    fpamr = fopen(pchAMRFileName, "rb");
    
	if ( fpamr==NULL ) return 0;
	
	// Check the amr file header
	fread(magic, sizeof(char), strlen(AMR_MAGIC_NUMBER), fpamr);
	if (strncmp(magic, AMR_MAGIC_NUMBER, strlen(AMR_MAGIC_NUMBER)))
	{
		fclose(fpamr);
		return 0;
	}
	
	// Initialize the wave file
//	NSArray *paths               = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentPath       = [paths objectAtIndex:0];
//	NSString *docFilePath        = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%s", pchWAVEFilename]];
//	NSLog(@"documentPath=%@", documentPath);
//	
//	fpwave = fopen([docFilePath cStringUsingEncoding:NSASCIIStringEncoding], "wb");
    fpwave = fopen(pchWAVEFilename,"wb");
    
	WriteWAVEFileHeader(fpwave, nFrameCount);
	
	/* init decoder */
	destate = Decoder_Interface_init();
	
	// Read the first frame as a reference frame
	memset(amrFrame, 0, MAX_AMR_FRAME_SIZE);
	memset(pcmFrame, 0, PCM_FRAME_SIZE);
	ReadAMRFrameFirst(fpamr, amrFrame, &stdFrameSize, &stdFrameHeader);
	
	// Decode an AMR audio frame to PCM data
	Decoder_Interface_Decode(destate, amrFrame, pcmFrame, 0);
	nFrameCount++;
	fwrite(pcmFrame, sizeof(short), PCM_FRAME_SIZE, fpwave);
	
	// Decode every frame of AMR and write to WAVE file
	while(1)
	{
		memset(amrFrame, 0, MAX_AMR_FRAME_SIZE);
		memset(pcmFrame, 0, PCM_FRAME_SIZE);
		if (!ReadAMRFrame(fpamr, amrFrame, stdFrameSize, stdFrameHeader)) break;
		
		// Decode the AMR audio frame to PCM data
        Decoder_Interface_Decode(destate, amrFrame, pcmFrame, 0);
		nFrameCount++;
		fwrite(pcmFrame, sizeof(short), PCM_FRAME_SIZE, fpwave);
	}
	//NSLog(@"frame = %d", nFrameCount);
	Decoder_Interface_exit(destate);
	
	fclose(fpwave);
	
	// Re-swrite the wave file header
//	fpwave = fopen([docFilePath cStringUsingEncoding:NSASCIIStringEncoding], "r+");
    fpwave = fopen(pchWAVEFilename, "r+");
	WriteWAVEFileHeader(fpwave, nFrameCount);
	fclose(fpwave);
	
	return nFrameCount;
}

int isMP3File(const char *filePath){
    FILE* fpamr = NULL;
    char magic[8];
    fpamr = fopen(filePath, "rb");
    if (fpamr==NULL) return 0;
    int isMp3 = 0;
    fread(magic, sizeof(char), strlen(MP3_MAGIC_NUMBER), fpamr);
    if (!strncmp(magic, MP3_MAGIC_NUMBER, strlen(MP3_MAGIC_NUMBER)))
    {
        isMp3 = 1;
    }
    fclose(fpamr);
    return isMp3;
}


int isAMRFile(const char *filePath){
    FILE* fpamr = NULL;
    char magic[8];
    fpamr = fopen(filePath, "rb");
    if (fpamr==NULL) return 0;
    int isAmr = 0;
    fread(magic, sizeof(char), strlen(AMR_MAGIC_NUMBER), fpamr);
    if (!strncmp(magic, AMR_MAGIC_NUMBER, strlen(AMR_MAGIC_NUMBER)))
    {
        isAmr = 1;
    }
    fclose(fpamr);
    return isAmr;
}
