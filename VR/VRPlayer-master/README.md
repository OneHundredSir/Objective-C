# VRPlayer

硬解播放flv（AAC+H264）
解析flv,分离音频、视频数据，ios audioqueue可直接播放AAC音频，videotoolbox解码h264用OpenGLES 显示yuv数据，

目前待解决问题，解码h264前，先根据pts排序，目前获取每一帧的pts有困难。
根据高人指点，pts应该是从flv中获取。

ds = tagheader的时间戳
pts = ds + CompositionTime
