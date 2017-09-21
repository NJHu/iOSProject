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

#ifndef WAV_H
#define WAV_H

#include <stdio.h>

class WavWriter {
public:
	WavWriter(const char *filename, int sampleRate, int bitsPerSample, int channels);
	~WavWriter();

	void writeData(const unsigned char* data, int length);

private:
	void writeString(const char *str);
	void writeInt32(int value);
	void writeInt16(int value);

	void writeHeader(int length);

	FILE *wav;
	int dataLength;

	int sampleRate;
	int bitsPerSample;
	int channels;
};

#endif

