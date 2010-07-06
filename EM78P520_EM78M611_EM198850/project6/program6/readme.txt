12月1日起 给艾瑞数码做的按键摇杆扫描采样工程

MCU:       EM78P520
Freq：     8MHz
通信方式： UART 
rate：     38400，没有校验位，8bit mode，1位停止位



WPiiP520ksV1.0_20091207_bate1.zip            初步测试通过。功能包含16按键阵列，独立方向按键，摇杆，带sleep功能，与上位机UART通信
WPiiP520ksV1.0_20091209_demo1.zip            给艾瑞演示demo
WPiiP520ksV1.0_20091209_demo2.zip            第一次烧录IC给艾瑞
WPiiP520ksV1.0_20091211_demo4.zip            与客户刘小林调试整合，确认功能后烧录。正式demo
EM198850 communication demo.zip              范汗章关于EM198850 demo

eUIDEP520ksv2.0_20100512_bak.zip             备份。准备增加触摸摇杆
eUIDEP520ksv2.0_20100513_init.rar            完成TP初始化
eUIDEP520ksv2.0_20100514_dataTime.zip        完成TP正常输出，但是非标准。按键离手时数值有记忆，应当为默认值。
eUIDEP520ksv2.0_20100518_loss.zip            16ms读数据判断有问题，经常漏数据              
eUIDEP520ksv2.0_20100519_check.zip           仿真送数据，TP已经能正常与蓝牙通信，除了灵敏度欠佳数据还可以
eUIDEP520ksv2.0_20100520_DataNoDefault.zip   通信正常，数据有误 不是默认值0x7f
eUIDEP520ksv2.0_20100520_valuedef.zip        改善默认值为0xff
eUIDEP520ksv2.0_TPdemo.zip                   TP demo


