package com.zy.SmartCampus.modbus;

import com.serotonin.modbus4j.serial.SerialPortWrapper;
import gnu.io.*;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;

public class SerialPortWrapperImpl implements SerialPortWrapper, SerialPortEventListener {
    //枚举类型
    Enumeration<CommPortIdentifier> portList;
    // 检测系统可用端口
    private CommPortIdentifier portIdentifier;
    // 端口
    private SerialPort port;
    // 输入/输出流
    private InputStream inputStream;
    private OutputStream outputStream;

    //虚拟ip192.168.10.22为串口com1

    @Override
    public void close() throws Exception {
    }

    @Override
    public void open() throws Exception {
        // 获得系统支持的所有端口（串口，并口）
        portList = CommPortIdentifier.getPortIdentifiers();

        while(portList.hasMoreElements()) {
            portIdentifier = (CommPortIdentifier)portList.nextElement();
            // CommPortIdentifier.PORT_SERIAL :串口
            // CommPortIdentifier.PORT_PARALLEL :并口
            // CommPortIdentifier.PORT_RS485 :RS485
            // CommPortIdentifier.PORT_I2C :I2C
            // CommPortIdentifier.PORT_RAW

            if (portIdentifier.getPortType() == CommPortIdentifier.PORT_SERIAL) {
                System.out.println(portIdentifier.getName());  //获取串口名字
                if (portIdentifier.getName().equals("COM3")) {
                    try {
                        // open:打开串口，第一个参数应用程序名称 字符串可随意填写，第二个参数阻塞时等待多少毫秒
                        port = (SerialPort)portIdentifier.open("COM3", 2000);
                        // 串口设置监听
                        port.addEventListener(this);
                        // 设置可监听
                        port.notifyOnDataAvailable(true);
                        // 设置串口通信参数
                        // 波特率，数据位，停止位，校验方式
                        port.setSerialPortParams(19200,
                                SerialPort.DATABITS_8,
                                SerialPort.STOPBITS_1,
                                SerialPort.PARITY_NONE);
                        outputStream = port.getOutputStream();
                        inputStream = port.getInputStream();

                        System.out.println("打开串口成功");

                    } catch (PortInUseException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }catch (UnsupportedCommOperationException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    @Override
    public InputStream getInputStream() {
        return inputStream;
    }

    @Override
    public OutputStream getOutputStream() {
        return outputStream;
    }

    @Override
    public int getBaudRate() {
        return 0;
    }

    @Override
    public int getFlowControlIn() {
        return 0;
    }

    @Override
    public int getFlowControlOut() {
        return 0;
    }

    @Override
    public int getDataBits() {
        return 0;
    }

    @Override
    public int getStopBits() {
        return 0;
    }

    @Override
    public int getParity() {
        return 0;
    }

    @Override
    public void serialEvent(SerialPortEvent serialPortEvent) {
        System.out.println("serialEvent");
    }
}
