function hr = ecgTohr(ecg,fs,h_all,m)
%h_all 采样总时间
%m 使用一次PT算法的采样时间，h_all是m的整数倍
%本次使用h_all=24，m=10

gr = 0;
windows = 30; %窗口30s，样本数6000
time = 0;
hr = [];
num = h_all*60/m;

for j = 1:num
	if j==1
		subecg =ecg(1:m*60*fs);
	else 
		subecg = ecg( ((j-1)*m*60*fs-fs+1):j*m*60*fs );
	end	     
	[qrs_amp_raw,qrs_i_raw,delay,ecg_h,pos_r]=pan_tompkin4(subecg,fs,gr); %r波检测
	ecg_new = ecg_h(fs+1:end);  %去掉第一秒的样本
	second = length(ecg_new)/fs;  %时间
	for i = 1:(second-30+1)
		starting=(i-1)*fs+1;
		ending=(i-1)*fs+windows*fs;
		if ending <= length(ecg_new)
			count = length(find(qrs_i_raw<=ending&qrs_i_raw>starting));
			hr = [hr count*2]; %更新hr
		end
	end
end