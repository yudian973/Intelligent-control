%==================================================================
	%释放串口设备对象
	fclose(scom)         ;
	delete(scom)         ;
	clear scom           ;
    isvalid(scom)        
	clear
    clc