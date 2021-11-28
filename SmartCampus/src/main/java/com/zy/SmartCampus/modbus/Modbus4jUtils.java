package com.zy.SmartCampus.modbus;

import com.serotonin.modbus4j.BatchRead;
import com.serotonin.modbus4j.BatchResults;
import com.serotonin.modbus4j.ModbusFactory;
import com.serotonin.modbus4j.ModbusMaster;
import com.serotonin.modbus4j.code.DataType;
import com.serotonin.modbus4j.exception.ErrorResponseException;
import com.serotonin.modbus4j.exception.ModbusInitException;
import com.serotonin.modbus4j.exception.ModbusTransportException;
import com.serotonin.modbus4j.ip.IpParameters;
import com.serotonin.modbus4j.locator.BaseLocator;
import com.serotonin.modbus4j.msg.*;

import java.util.ArrayList;

/**
 * modbus通讯工具类,采用modbus4j实现
 *
 * @author lxq
 * @dependencies modbus4j-3.0.3.jar
 * @website https://github.com/infiniteautomation/modbus4j
 */
public class Modbus4jUtils {






//    public static void modbusWTCP(String ip, int port, int slaveId, int start, short[] values) {
//        ModbusFactory modbusFactory = new ModbusFactory();
//        // 设备ModbusTCP的Ip与端口，如果不设定端口则默认为502
//        IpParameters params = new IpParameters();
//        params.setHost(ip);
//        if (502 != port) {
//            params.setPort(port);
//        }
//        // 设置端口，默认502
//        ModbusMaster tcpMaster = null;
//        // 参数1：IP和端口信息 参数2：保持连接激活
//        tcpMaster = modbusFactory.createTcpMaster(params, true);
//        try {
//        tcpMaster.init();
//
//        System.out.println("===============" + 1111111);
//
//        } catch (ModbusInitException e) {
//        System.out.println("================ 2 "+e.toString());
//        // System.out.println("11111111111111=="+"此处出现问题了啊!");
//        // 如果出现了通信异常信息，则保存到数据库中
//        //CommunityExceptionRecord cer = new CommunityExceptionRecord();
//        //cer.setDate(new Date());
//        //cer.setIp(ip);
//        // cer.setRemark(bgName+"出现连接异常");
//        // batteryGroupRecordService.saveCommunityException(cer);
//        }
//        try {
//            WriteRegistersRequest request = new WriteRegistersRequest(slaveId, start, values);
//            WriteRegistersResponse response = (WriteRegistersResponse) tcpMaster.send(request);
//            if (response.isException())
//                System.out.println("Exception response: message=" + response.getExceptionMessage());
//            else
//                System.out.println("Success");
//        } catch (ModbusTransportException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public static ByteQueue modbusTCP(String ip, int port, int start, int readLenth) {
//        ModbusFactory modbusFactory = new ModbusFactory();
//        // 设备ModbusTCP的Ip与端口，如果不设定端口则默认为502
//        IpParameters params = new IpParameters();
//        params.setHost(ip);
//        if(502!=port){
//            //设置端口，默认502
//            params.setPort(port);
//        }
//        ModbusMaster tcpMaster = null;
//        tcpMaster = modbusFactory.createTcpMaster(params, true);
//        try {
//            tcpMaster.init();
//            System.out.println("==============="+1111111);
//        } catch (ModbusInitException e) {
//            return null;
//        }
//        ModbusRequest modbusRequest=null;
//        try {
//            modbusRequest = new ReadHoldingRegistersRequest(2, start, readLenth);
//        } catch (ModbusTransportException e) {
//            e.printStackTrace();
//        }
//        ModbusResponse modbusResponse=null;
//        try {
//            modbusResponse = tcpMaster.send(modbusRequest);
//        } catch (ModbusTransportException e) {
//            e.printStackTrace();
//        }
//        ByteQueue byteQueue= new ByteQueue(12);
//        modbusResponse.write(byteQueue);
//        System.out.println("功能码:"+modbusRequest.getFunctionCode());
//        System.out.println("从站地址:"+modbusRequest.getSlaveId());
//        System.out.println("收到的响应信息大小:"+byteQueue.size());
//        System.out.println("收到的响应信息值:"+byteQueue);
//        return byteQueue;
//    }
//
//    //MODBUS网络上从站地址
//    public final static int SLAVE_ADDRESS=2;
//
//    //串行口波特率
//    public final static int BAUD_RATE = 9600;
//
//    /**
//    * 读开关量型的输入信号
//    * @param master 主站
//    * @param slaveId 从站地址
//    * @param start 起始偏移量
//    * @param len 待读的开关量的个数
//    */
//    public static void readDiscreteInputTest(ModbusMaster master, int slaveId, int start, int len) {
//        try {
//            ReadDiscreteInputsRequest request = new ReadDiscreteInputsRequest(slaveId, start, len);
//            ReadDiscreteInputsResponse response = (ReadDiscreteInputsResponse) master.send(request);
//        if (response.isException())
//            System.out.println("Exception response: message=" + response.getExceptionMessage());
//        else
//            System.out.println(Arrays.toString(response.getBooleanData()));
//        }
//        catch (ModbusTransportException e) {
//            e.printStackTrace();
//        }
//    }
//
//    /**
//    * 读保持寄存器上的内容
//    * @param master 主站
//    * @param slaveId 从站地址
//    * @param start 起始地址的偏移量
//    * @param len 待读寄存器的个数
//    */
//    public static void readHoldingRegistersTest(ModbusMaster master, int slaveId, int start, int len) {
//        try {
//        ReadHoldingRegistersRequest request = new ReadHoldingRegistersRequest(slaveId, start, len);
//        ReadHoldingRegistersResponse response = (ReadHoldingRegistersResponse) master.send(request);
//        if (response.isException())
//            System.out.println("Exception response: message=" + response.getExceptionMessage());
//        else
//            System.out.println(Arrays.toString(response.getShortData()));
//        }
//        catch (ModbusTransportException e) {
//            e.printStackTrace();
//        }
//    }
//
//    /**
//    * 批量写数据到保持寄存器
//    * @param master 主站
//    * @param slaveId 从站地址
//    * @param start 起始地址的偏移量
//    * @param values 待写数据
//    */
//    public static void writeRegistersTest(ModbusMaster master, int slaveId, int start, short[] values) {
//        try {
//            WriteRegistersRequest request = new WriteRegistersRequest(slaveId, start, values);
//            WriteRegistersResponse response = (WriteRegistersResponse) master.send(request);
//        if (response.isException())
//            System.out.println("Exception response: message=" + response.getExceptionMessage());
//        else
//            System.out.println("Success");
//        }
//        catch (ModbusTransportException e) {
//            e.printStackTrace();
//        }
//    }

    
/*********************************************************************************************************************************************/



    /**
     * 工厂。
     */
    static ModbusFactory modbusFactory;

    static {
        if (modbusFactory == null) {
            modbusFactory = new ModbusFactory();
        }
    }
    /**
     * 获取master
     *
     * @return
     * @throws ModbusInitException
     */
    public static ModbusMaster getIpMaster(String host, int port) throws ModbusInitException {
        IpParameters params = new IpParameters();
        params.setHost(host);
        params.setPort(port);
        //modbusFactory.createTcpMaster(params, false)  //TCP 协议
        // modbusFactory.createRtuMaster(wapper); //RTU 协议
        // modbusFactory.createUdpMaster(params);//UDP 协议
        // modbusFactory.createAsciiMaster(wrapper);//ASCII 协议
        ModbusMaster master = modbusFactory.createTcpMaster(params, false);// TCP 协议
        master.init();

        return master;
    }
    public static ModbusMaster getRtuIpMaster(String host, int port) {
        IpParameters params = new IpParameters();
        params.setHost(host);
        params.setPort(port);
        //这个属性确定了协议帧是否是通过tcp封装的RTU结构，采用modbus tcp/ip时，要设为false, 采用modbus rtu over tcp/ip时，要设为true
        params.setEncapsulated(true);
        ModbusMaster master = modbusFactory.createTcpMaster(params, false);
        try {
            //设置超时时间
            master.setTimeout(1000);
            //设置重连次数
            master.setRetries(3);
            //初始化
            master.init();
        } catch (ModbusInitException e) {
            e.printStackTrace();
        }
        return master;
    }

    /**
     * 获取master
     *
     * @return
     * @throws ModbusInitException
     */
    public static ModbusMaster getComRtuMaster() throws ModbusInitException {
        ModbusMaster master1 = modbusFactory.createRtuMaster(new SerialPortWrapperImpl());
        master1.init();
        return master1;
    }

    /**
     * 读取[01 Coil Status 0x]类型 开关数据
     *
     * @param slaveId slaveId
     * @param offset  位置
     * @return 读取值
     * @throws ModbusTransportException 异常
     * @throws ErrorResponseException   异常
     * @throws ModbusInitException      异常
     */
    public static Boolean readCoilStatus(ModbusMaster master, int slaveId, int offset)
            throws ModbusTransportException, ErrorResponseException, ModbusInitException {
        // 01 Coil Status
        BaseLocator<Boolean> loc = BaseLocator.coilStatus(slaveId, offset);
        Boolean value = master.getValue(loc);
        return value;
    }

    /**
     * 读取[02 Input Status 1x]类型 开关数据
     *
     * @param slaveId
     * @param offset
     * @return
     * @throws ModbusTransportException
     * @throws ErrorResponseException
     * @throws ModbusInitException
     */
    public static Boolean readInputStatus(ModbusMaster master, int slaveId, int offset) throws ModbusTransportException, ErrorResponseException {
        // 02 Input Status
        BaseLocator<Boolean> loc = BaseLocator.inputStatus(slaveId, offset);
        Boolean value = master.getValue(loc);
        return value;
    }

    /**
     * 读取[03 Holding Register类型 2x]模拟量数据
     *
     * @param slaveId  slave Id
     * @param offset   位置
     * @param dataType 数据类型,来自com.serotonin.modbus4j.code.DataType
     * @return
     * @throws ModbusTransportException 异常
     * @throws ErrorResponseException   异常
     * @throws ModbusInitException      异常
     */
    public static Number readHoldingRegister(ModbusMaster master, int slaveId, int offset, int dataType)
            throws ModbusTransportException, ErrorResponseException, ModbusInitException {
        // 03 Holding Register类型数据读取
        BaseLocator<Number> loc = BaseLocator.holdingRegister(slaveId, offset, dataType);
        Number value = master.getValue(loc);
        return value;
    }

    /**
     * 读取[04 Input Registers 3x]类型 模拟量数据
     *
     * @param slaveId  slaveId
     * @param offset   位置
     * @param dataType 数据类型,来自com.serotonin.modbus4j.code.DataType
     * @return 返回结果
     * @throws ModbusTransportException 异常
     * @throws ErrorResponseException   异常
     * @throws ModbusInitException      异常
     */
    public static Number readInputRegisters(ModbusMaster master, int slaveId, int offset, int dataType)
            throws ModbusTransportException, ErrorResponseException, ModbusInitException {
        // 04 Input Registers类型数据读取
        BaseLocator<Number> loc = BaseLocator.inputRegister(slaveId, offset, dataType);
        Number value = master.getValue(loc);
        return value;
    }

    /**
     * 批量读取使用方法
     *
     * @throws ModbusTransportException
     * @throws ErrorResponseException
     * @throws ModbusInitException
     */
    public static void batchRead(ModbusMaster master, ArrayList data) throws ModbusTransportException, ErrorResponseException, ModbusInitException {

        BatchRead<Integer> batch = new BatchRead<Integer>();

        batch.addLocator(0, BaseLocator.holdingRegister(1, 1, DataType.FOUR_BYTE_FLOAT));
        batch.addLocator(1, BaseLocator.inputStatus(1, 0));


        batch.setContiguousRequests(false);
        BatchResults<Integer> results = master.send(batch);
        System.out.println(results.getValue(0));
        System.out.println(results.getValue(1));
    }


    /**
     *
     * 写入[03 Holding Register(4x)]写多个 function ID=16
     *
     * @param slaveId
     *            modbus的slaveID
     * @param startOffset
     *            起始位置偏移量值
     * @param sdata
     *            写入的数据
     * @return 返回是否写入成功
     * @throws ModbusTransportException
     * @throws ModbusInitException
     */
    public static boolean writeRegisters(ModbusMaster tcpMaster,int slaveId, int startOffset, short[] sdata) throws ModbusTransportException {
        // 创建请求对象
        WriteRegistersRequest request = new WriteRegistersRequest(slaveId, startOffset, sdata);
        // 发送请求并获取响应对象
        ModbusResponse response = tcpMaster.send(request);
        if (response.isException()) {
            System.out.println(response.getExceptionMessage());
            return false;
        } else {
            return true;
        }
    }

}