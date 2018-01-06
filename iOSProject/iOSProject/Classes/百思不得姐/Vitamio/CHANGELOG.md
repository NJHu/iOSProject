## v4.2.0

- Add support arm64/x86_64 support;
- Add support HLS AES-128 secret stream;
- Add support download-playback HLS stream;
- Support for custom FFmpeg;
- Support swith video view between window and full screen;
- Improve seek operation.


## v1.1.3

- Add new API `setDataSegmentsSource:fileList:` for play media segments list;
- Add new API `setOptionsWithKeys:withValues:` for pass user options to media player;
- Add support backgroud playing;
- Add optimization for play MMS/RTMP stream;


## v1.1.1

- Compatible with link flag '-all_load'


## v1.1.0

- Support armv7/armv7s/i386(simulator);
- Support use ffmpeg library build by yourself;
- Fix bug for memory leak when no video stream output;
- Fix other bugs.


## v1.0.0

- Core Features.
	- Network protocols support.
	- Media formats support
	- Hardware decoder support
	- Subtitles support

- Network Protocols Support
	- MMS
	- RTSP (RTP, SDP), RTMP
	- HTTP progressive streaming
	- HLS - HTTP live streaming (M3U8)

- Media Formats Support
	- MPEG-4,H.264,RMVB,XVID
	- MS MPEG-4,VP6,H.263
	- MPEG-1,MPEG-2
	- AVI,MOV,MKV,FLV,AVI,3GP
	- 3G2,ASF,WMV,MP4,M4V
	- TP,TS,MTP,M2T

- Audio Support
	- Mutitiple subtitles support
	- AAC,Vorbis,FLAC,MP3,MP2,WMA

- Hardware decoder Support
	- MKV ,MOV.M4V
	- AVI,MP4,3GP
	- FLV,DivX/Xvid
	- TS/TP

- Subtitles
	- SubRip(.srt)
	- SubStation Alpha(.ssa)
	- Advanced Sub Station Alpha(.ass)
	- SAMI(.smi/.sami)
	- MicroDVD(.sub/.txt)
	- SubViewer2.0(.sub)
	- MPL2(.mpl/.txt)
	- Matroska (.mkv) Built-in subtitles
