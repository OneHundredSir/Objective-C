//
//  BluetoothManager.h
//  BluetoothFunctionSDK
//
//  Created by user on 16/6/3.
//  Copyright © 2016年 user. All rights reserved.
//

/**
 *  
    蓝牙管理单例对象 通过shardBluetoothManager()调用
    作为中心设备对外设连接进行管理
    仅支持单外设连接的操作
    链式编程，通过点语法调用方法
    必须在设置委托对象后才可开始使用
    具体使用见Demo
 *
 */
#warning == 连接外设成功后会启动防劫持功能，非认证外设会自动断开 ==

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol PeripheralCallbackDelegate;
@protocol ClientCallbackDelegate;


@interface BluetoothManager : NSObject

#pragma mark - 初始化蓝牙管理器方法

#pragma mark == 蓝牙管理单例对象 ==
/**
 *  单例蓝牙管理对象 使用该方法调用管理器对象
 */
extern BluetoothManager *shardBluetoothManager();

#pragma mark == 已连接外设 ==
/**
 *  已连接的外设
    连接外设成功后持有
    断开置为nil
    (目前仅支持单外设连接管理)
 */
@property (nonatomic,strong,readonly) CBPeripheral *connectedPeripheral;


#pragma mark == 设置委托对象 ==
/**
 *  设置委托 返回BOOL判断是否设置成功
    设置成功后才可使用中心管理器方法
    需保证委托对象被其他对象强持有且常驻内存
    否则被销毁后无法调用和再次设置委托
 
    委托对象需遵守两个协议： ClientCallbackDelegate，
                         PeripheralCallbackDelegate
    委托方法:
    updateStateWithCentralManager:
 */
@property (nonatomic,copy,readonly) BOOL ((^setDelegate)(id <ClientCallbackDelegate,PeripheralCallbackDelegate> delegate));

#pragma mark - 中心操作方法

#pragma mark == 扫描外设 ==
/**
 *  扫描外设的AllowDuplicatesKey BOOL设置 默认为NO
 */
@property (nonatomic,assign) BOOL AllowDuplicatesKey;
/**
 *  指定的服务UUID进行筛选 默认为nil
 */
@property (nonatomic,strong) NSArray <CBUUID *>*scanServiceUUIDs;
/**
 *  扫描外设
 
    委托方法: 
    didDiscoverPeripheral:advertisementData:RSSI:
 */
@property (nonatomic,copy,readonly) BluetoothManager *((^startScan) ());


#pragma mark == 停止扫描外设 ==
/**
 *  停止扫描外设
 */
@property (nonatomic,copy,readonly) BluetoothManager *((^stopScan) ());


#pragma mark == 连接外设 ==
/**
 *  以为选项默认为NO
 */
@property (nonatomic,assign) BOOL CBConnectPeripheralOptionNotifyOnConnectionKey;
@property (nonatomic,assign) BOOL CBConnectPeripheralOptionNotifyOnDisconnectionKey;
@property (nonatomic,assign) BOOL CBConnectPeripheralOptionNotifyOnNotificationKey;
/**
 *  连接指定外设 并自动停止扫描
 
    委托方法:
    连接成功 didConnectPeripheral:
    连接失败 didFailToConnectPeripheral:error:
 */
@property (nonatomic,copy,readonly) BluetoothManager *((^connectPeripheral) (CBPeripheral *peripheral));


#pragma mark == 断开外设 ==
/**
 *  断开指定外设
 
    委托方法:
    didDisconnectPeripheral:error:
 */
@property (nonatomic,copy,readonly) BluetoothManager *((^disconnectPeripheral) (CBPeripheral *peripheral));


@end


#pragma mark - 中心操作协议 均要求实现
@protocol ClientCallbackDelegate <NSObject>

@required
#pragma mark == 蓝牙状态更新 委托方法 ==
/**
 *  .setDelegate(delegate)
 *
 *  设置委托对象成功后回调 才能进行蓝牙操作
 *
 *  @param centralManager 中心设备 通过state属性判断其状态
 */
- (void)updateStateWithCentralManager:(CBCentralManager *)centralManager;


#pragma mark == 扫描外设 委托方法 ==
/**
 *  .startScan()
 *
 *  @param peripheral        扫描到的外设
 *  @param advertisementData 外设广播包
 *  @param RSSI              RSSI
 */
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral
            advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                         RSSI:(NSNumber *)RSSI;


#pragma mark == 连接外设成功 委托方法 ==
/**
 *   .connectPeripheral(peripheral) 
 *
 *   会自动调用 检索外设服务方法
 *   成功连接后 由中心管理的connectedPeripheral属性持有该对象
 *
 *  @param peripheral 成功连接的外设
 *
 */
- (void)didConnectPeripheral:(CBPeripheral *)peripheral;


#pragma mark == 外设连接失败 委托方法 ==
/**
 *  .connectPeripheral(peripheral)
 *
 *  @param peripheral 连接失败的外设
 *  @param error      错误信息
 *
 */
- (void)didFailToConnectPeripheral:(CBPeripheral *)peripheral
                             error:(NSError *)error;


#pragma mark == 外设断开连接 委托方法 ==
/**
 *  .disconnectPeripheral(peripheral)
 *
 *  @param peripheral 断开连接的外设
 *  @param error      错误信息
 *
 *  同连接失败 会将connectedPeripheral置为nil
 */
- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral
                          error:(NSError *)error;

@end
