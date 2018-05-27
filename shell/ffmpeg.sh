#!/bin/bash

# 录屏
ffmpeg -f x11grab -s wxga -r 25 -i :0.0 /tmp/out.mpg
ffmpeg -f x11grab -video_size 1440x900 -i :1 -r 30 -b 1M out.mkv

# 顺时针旋转90度并水平翻转
ffmpeg -i 1.mkv -filter_complex "transpose=1,hflip" out.mkv
ffmpeg -i 1.mkv -vf transpose=3 out.mkv
# 逆时针旋转90度并垂直翻转
ffmpeg -i 1.mkv -vf transpose=0 out.mkv

# 宽度扩大两倍
ffmpeg -i 1.mkv -t 10 -vf pad=2*iw out.mkv
# 水平翻转并覆盖
ffmpeg  -i 1.mkv -t 10 -vf hflip out1.mkv
ffmpeg -i 1.mkv -i out1.mkv -filter_complex overlay=w out2.mkv
ffplay -i 1.mkv -filter_complex "splite[a][b];[a]pad=2*iw[1];[b]hflip[2];[1][2]overlay=w" out.mkv

# 缩放到一半大小
ffmpeg -i 1.mkv -vf scale=iw/2:ih/2 out.mkv
# 保持寬高比
ffmpeg -i 1.mkv -vf scale=400:400/a
ffmpeg -i 1.mkv -vf scale=400:-1
ffmpeg -i 1.mkv -vf scale=300*a:300
ffmpeg -i 1.mkv -vf scale=-1:300

# 裁剪左三分之一
ffmpeg -i 1.mkv -vf crop=iw/3:ih :0:0 out.mkv
# 纵向中间三分之一
ffmpeg -i 1.mkv -vf crop=iw/3:ih:iw/3:0 out.mkv
# 横向中间三分之一
ffmpeg -i 1.mkv -vf crop=iw:ih/3:0:ih/3 out.mkv
# 比较裁剪后的视频和源视频
ffmpeg -i 1.mkv -filter_complex "split[a][b];[a]drawbox=x=(iw-300)/2:(ih-300)/2:w=300:h=300:c=yellow[A];[A]pad=2*iw[C];[b]crop=300:300:(iw-300)/2:(ih-300)/2[B];[C][B]overlay=w*2.4:40" out.mkv

# 自动检测裁剪区域
ffmpeg -i 1.mkv -vf cropdetect out.mkv

# 填充
ffmpeg -i 1.mkv -vf pad=860:660:30:30:pink out.mkv
ffmpeg -i 1.mkv -vf pad=iw+60:ih+60:30:30:pink out.mkv

# 4:3 到16:9
ffmpeg -i 1.mkv -filter_complex "pad=ih*16/9:ih:(ow-iw)/2:0:pink" out.mkv
# 16:9 到 4:3
ffmpeg -i 1.mkv -filter_complex "pad=iw:iw*3/4:0:(oh-ih)/2:pink" out.mkv

# 模糊
ffmpeg -i 1.mkv -vf boxblur out.mkv
# 锐化
ffmpeg -i 1.mkv -f unsharp out.mkv

# pip
ffmpeg -i 1.mkv -i 2.mkv -filter_complex "[0:v]scale=1440x900[a],[1:v]scale=720x450[b]; [a][b]overlay=1:x=720:y=450" -c:v libx264 -c:a copy pip.mkv
# 3blocks
ffmpeg -i 1.mkv -i 2.mkv -i 3.mkv -filter_complex "nullsrc=size=1440x900[base];[0:v]scale=720x450[a]; [base][a]overlay=0:x=360:y=0[o1]; [1:v]scale=720x450[b]; [o1][b]overaly=1:x=0:y=450[o2]; [2:v]scale=720x450[c];[o2][c]overlay=2:x=720:y=450" -c:v libx264 -c:a copy 3blocks.mkv
# 4blocks
ffmepg -i 1.mkv -i 2.mkv -i 3.mkv -i 4.mkv -filter_complex "nullsrc=size=640x480[base];[0:v]setpts=PTS-STARTPTS, scale=320x240[upperleft]; [1:v]setpts=PTS-STARTPTS, scal=320x240[upperright]; [2:v]setpts=PTS-STARTPTS, scal=320x240[lowerleft]; [3:v]setpts=PTS-STARTPTS, scal=320x240[lowerright]; [base][upperleft] overlay=shortest=1[tmp1]; [tmp1][upperright] overlay=shortest=1:x=320[tmp2]; [tmp2][lowerleft]overlay=shortest=1:y=240[tmp3];[tmp3][lowerright] overlay=shortest=1:x=320:y=240" -c:v libx264 out.mkv

# logo左上角
ffmpeg -i 1.mkv -i logo.png -filter_complex overlay out.mkv
ffmpeg -i 1.mkv -i logo.png -filter_complex "[0]scale=640x480[a];[1]scale=30x30[b];[a][b]overlay" out.mkv
# logo右下角
ffmpeg -i 1.mkv -i logo.png -filter_complex overlay=W-w:H-h out.mkv
# 删除logo 删除(50,50)位置上60x60的logo，并填充一个边缘厚度为100的矩形
ffmpeg -i 1.mkv -vf delogo=50:51:60:60:100:1 out.mkv

# 添加文本
ffmpeg -i 1.mkv  -filter_complex "drawtext=fontfile=/usr/share/fonts/TTF/DejaVuSans.ttf:text='Goodday':x=(w-tw)/2:y=(h-th)/2:fontcolor=green:fontsize=30" out.mkv
# 动态文本
ffmpeg -i 1.mkv -filter_complex "drawtext=fontfile=/usr/share/fonts/TTF/DejaVuSans.ttf:text='Goodday':x=w-t*50:fontcolor=darkorange:fontsize=30" out.mkv
# 现实当前时间
ffmpeg -i 1.mkv -filter_complex "drawtext=fontfile=/usr/share/fonts/TTF/DejaVuSans.ttf:x=w-tw:fontcolor=green:fontsize=30:text=%{localtime\\\:%H.%M.%S}:enable=lt(mod(t\,1)\,1)" out.mkv


# 截图
ffmpeg -ss 00:00:03 -i 1.mkv out.jepg
# 生成gif
ffmpeg -ss 00:00:03 -i 1.mkv -t 3 -pix_fmt rgb24 out.gif
# 转化视频为图像，每帧一张图
ffmpeg -i 1.mkv frame%4d.jpg
# 每20秒截图一战
ffmpeg -i 1.mkv -f image2 -vf fps=fps=1/20 out%d.png
# 图像转换为视频
ffmpeg -i image2 -i frame%4d.jpg -r 25 out.mkv
# 裁剪图片
ffmpeg -i frame.jpg -vf crop=150:150 out.jpg
# 填充图片
ffmpeg -i frame.jpg -vf pad=iw+60:ih+60:30:30:pink out.jpg
# 翻转图片
ffmpeg -i frame.jpg -vf hflip out.jpg
ffmpeg -i frame.jpg -vf vflip out.jpg
# 覆盖图片
ffmpeg -i frame.jpg -s 400x300 out.jpg
ffmpeg -i frame1.jpg -i frame2.jpg -filter_complex "overlay=(W-w)/2:(H-h)/2" out.jgp


# 添加字幕
ffmpeg -i 1.mkv -vf subtitles=xxx.srt out.mkv

# 色彩平衡
ffmpeg -i 1.mkv -vf curves=vintage
# 色彩变换
ffmpeg -i 1.mkv -vf hue="H=2*PI*t: s=sin(2*PI*t)+1" out.mkv

# 视频播放速度 3倍速
ffplay -i 1.mkv -vf setpts=PTS/3
# 音频播放速度 2倍速
ffplay -i 1.mp3 -af atempo=2

# 转码得到高质量视频
#ffmpeg.exe -i "D:\Video\Fearless\Fearless.avi" -target film-dvd -s 720x352 -padtop 64 -padbottom 64 -maxrate 7350000 -b 3700000 -sc_threshold 1000000000 -trellis -cgop -g 12 -bf 2 -qblur 0.3 -qcomp 0.7 -me full -dc 10 -mbd 2 -aspect 16:9 -pass 2 -passlogfile "D:\Video\ffmpegencode" -an -f mpeg2video "D:\Fearless.m2v"
