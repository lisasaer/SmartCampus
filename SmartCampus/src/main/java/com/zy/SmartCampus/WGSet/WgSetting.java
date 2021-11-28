package com.zy.SmartCampus.WGSet;

import com.zy.SmartCampus.hik.HkStaticInfo;
import com.zy.SmartCampus.polo.LoginDevInfo;
import org.springframework.stereotype.Component;

@Component
public class WgSetting {

    /**
     * 根据设备IP返回注册设备信息
     * @param strIP
     * @return
     */
    public static LoginDevInfo getLoginWgDevInfoByDevID(String strIP){
        LoginDevInfo loginDevInfo = null;
        System.out.println(strIP);
        System.out.println(loginDevInfo);
        System.out.println(WgDevStaticInfo.g_loginDevInfoList);
        for(LoginDevInfo temp: WgDevStaticInfo.g_loginDevInfoList){
            System.out.println(1);
            if (strIP.equals(temp.getStrDevIP()) ){
                System.out.println(2);
                loginDevInfo = temp;
                break;
            }
        }
        System.out.println(3);
        return loginDevInfo;
    }


}
