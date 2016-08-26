//
//  BluetoothManager.m
//  BluetoothFunctionSDK
//
//  Created by user on 16/6/3.
//  Copyright © 2016年 user. All rights reserved.
//

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#import <UIKit/UIKit.h>
#import "BluetoothManager.h"

#import "BluetoothManager+PeripheralOperation.h"
#import "VerifyModuel.h"

#define kCOM_NAME @"BUILDWIN"
static BluetoothManager *_staticInstance;

inline BluetoothManager *shardBluetoothManager() {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _staticInstance = [[BluetoothManager alloc] init];
    });
    return _staticInstance;
}

@interface BluetoothManager () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) CBCentralManager *centralManager;

@property (nonatomic,copy,readonly) BluetoothManager * (^setClientCallbackDelegate) (id<ClientCallbackDelegate,PeripheralCallbackDelegate> clientCallbackDelegate);

@property (nonatomic,weak) id <ClientCallbackDelegate,PeripheralCallbackDelegate> clientCallbackDelegate;

@property (nonatomic,strong) VerifyModuel *verifyModel;

@end

@implementation BluetoothManager
{
    /**
     *  蓝牙串行队列
     */
    dispatch_queue_t _BLEQueue;
}
#pragma mark == 初始化方法 ==
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.verifyModel = [[VerifyModuel alloc] init];
        _BLEQueue = dispatch_queue_create("BLEQueue", DISPATCH_QUEUE_SERIAL);
        self.AllowDuplicatesKey = NO;
        self.scanServiceUUIDs = nil;
        self.CBConnectPeripheralOptionNotifyOnConnectionKey = NO;
        self.CBConnectPeripheralOptionNotifyOnDisconnectionKey = NO;
        self.CBConnectPeripheralOptionNotifyOnNotificationKey = NO;
    }
    return self;
}

#pragma mark == 设置代理 ==
- (BOOL ((^)(id<ClientCallbackDelegate,PeripheralCallbackDelegate>)))setDelegate {
    
    return ^(id <ClientCallbackDelegate,PeripheralCallbackDelegate> delegate){
      
        BOOL isSucced;
        
        if ([delegate conformsToProtocol:@protocol(ClientCallbackDelegate)] && [delegate conformsToProtocol:@protocol(PeripheralCallbackDelegate)]) {
            
            shardBluetoothManager().setClientCallbackDelegate(delegate);
            isSucced = YES;
        }
        return isSucced;
    };
}

#pragma mark == 只会执行一次设置代理动作 ==
- (BluetoothManager *(^)(id<ClientCallbackDelegate,PeripheralCallbackDelegate>))setClientCallbackDelegate {
    
    return ^(id <ClientCallbackDelegate,PeripheralCallbackDelegate> delegate){
      
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _clientCallbackDelegate = delegate;
            self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_BLEQueue];
        });
        return self;
    };
}

#pragma mark - 中心设备指令
#pragma mark == 开始扫描外设 ==
- (BluetoothManager *((^)()))startScan {
    
    return ^(){
        
        NSDictionary *dict = @{@"CBCentralManagerScanOptionAllowDuplicatesKey":@(self.AllowDuplicatesKey)};
        [self.centralManager scanForPeripheralsWithServices:self.scanServiceUUIDs options:dict];
        return self;
    };
}

#pragma mark == 停止扫描外设 ==
- (BluetoothManager *((^)()))stopScan {
    
    return ^(){
        
        [self.centralManager stopScan];
        return self;
    };
}


#pragma mark == 连接外设 ==
- (BluetoothManager *((^)(CBPeripheral *)))connectPeripheral {
    
    return ^(CBPeripheral *peripheral){
        
        if (self.connectedPeripheral) {
            
            return self;
        }
        
        if (peripheral.state == CBPeripheralStateDisconnected) {
            
            [self.centralManager stopScan];
            
            [self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@(self.CBConnectPeripheralOptionNotifyOnConnectionKey),CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(self.CBConnectPeripheralOptionNotifyOnDisconnectionKey),CBConnectPeripheralOptionNotifyOnNotificationKey:@(self.CBConnectPeripheralOptionNotifyOnNotificationKey)}];
        }
        return self;
    };
}

#pragma mark == 断开外设连接 ==
- (BluetoothManager *((^)(CBPeripheral *)))disconnectPeripheral {
    
    return ^(CBPeripheral *peripheral){
        
        if (peripheral && ( peripheral.state == CBPeripheralStateConnected )) {
            
            [self.centralManager cancelPeripheralConnection:peripheral];
        }
        return self;
    };
}

#pragma mark - 外设操作指令


#pragma mark == 检索外设服务 ==
- (BluetoothManager *((^)()))discoverServicesWithConnectedPeripheral {
    
    return ^(){
        
        if (self.connectedPeripheral) {
            
            [self.connectedPeripheral discoverServices:nil];
        }
        return self;
    };
}


#pragma mark == 检索外设特征 ==
- (BluetoothManager *((^)()))discoverCharacteristicsWithConnectedPeripheral {
    
    return ^(){
        
        if (self.connectedPeripheral) {
            
            for (CBService *service in self.connectedPeripheral.services) {
                
                [self.connectedPeripheral discoverCharacteristics:nil forService:service];
            }
        }
        return self;
    };
}


#pragma mark == 读取目标特征数据 ==
-(BluetoothManager *((^)(CBCharacteristic *)))readValueWithCharacteristic {
    
    return ^(CBCharacteristic *characteristic){
        
        if (self.connectedPeripheral && characteristic) {
            
            if (characteristic.properties & CBCharacteristicPropertyRead) {
                
                [self.connectedPeripheral readValueForCharacteristic:characteristic];
            }
        }
        return self;
    };
}

#pragma mark == 向目标特征写入数据 ==
- (BluetoothManager *((^)(CBCharacteristic *, NSData *)))writeValueWithCharacteristicAndValue {
    
    return ^(CBCharacteristic *characteristic,NSData *value){
        
        if (self.connectedPeripheral && characteristic && value) {
            
            CBCharacteristicWriteType type;
            
            if (characteristic.properties & CBCharacteristicPropertyWrite) {
                
                type=CBCharacteristicWriteWithResponse;
            }
            else if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse){
                
                type=CBCharacteristicWriteWithoutResponse;
            }
            
            [self.connectedPeripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
        return self;
    };
}

#pragma mark == 设置目标特征订阅状态 ==
- (BluetoothManager *((^)(CBCharacteristic *, BOOL)))setNotifyWithCharacteristic {
    
    return ^(CBCharacteristic *characteristic,BOOL isNotify){
        
        if (self.connectedPeripheral && characteristic) {
            
            if ((characteristic.properties & CBCharacteristicPropertyNotify) || (characteristic.properties & CBCharacteristicPropertyIndicate)) {
                
                [self.connectedPeripheral setNotifyValue:isNotify forCharacteristic:characteristic];
            }
        }
        return self;
    };
}

#pragma mark == 检索指定特征描述者 ==
- (BluetoothManager *((^)(CBCharacteristic *)))discoverDescriptWithCharacteristic {
    
    return ^(CBCharacteristic *characteristic) {
        
        [self.connectedPeripheral discoverDescriptorsForCharacteristic:characteristic];
        
        return self;
    };
}

#pragma mark == 读取指定描述者数据 ==
- (BluetoothManager *((^)(CBDescriptor *)))readValueForDescriptor {
    
    return ^(CBDescriptor *descriptor){
        
        [self.connectedPeripheral readValueForDescriptor:descriptor];
        
        return self;
    };
}

#pragma mark == 向指定描述者写入数据 ==
- (BluetoothManager *((^)(CBDescriptor *, NSData *)))writeValueForDescriptorAndValue {
    
    return ^(CBDescriptor *descriptor,NSData *value){
        
        [self.connectedPeripheral writeValue:value forDescriptor:descriptor];
        
        return self;
    };
}

#pragma mark == 读取外设当前RSSI ==
- (BluetoothManager *((^)()))readRSSI {
    
    return ^(){
        
        [self.connectedPeripheral readRSSI];
        
        return self;
    };
}


#pragma mark - 中心设备回调

#pragma mark == centralManager状态更新代理方法 ==
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

    if ([self.clientCallbackDelegate respondsToSelector:@selector(updateStateWithCentralManager:)]) {
        
        [self.clientCallbackDelegate updateStateWithCentralManager:central];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'updateStateWithCentralManager:'");
    }
}

#pragma mark == 扫描到外设 ==
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSData *data=advertisementData[CBAdvertisementDataManufacturerDataKey];
    NSString *nameStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![nameStr isEqualToString:kCOM_NAME]) {
        
        return;
    }
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didDiscoverPeripheral:advertisementData:RSSI:)]) {
        
        [self.clientCallbackDelegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didDiscoverPeripheral:advertisementData:RSSI:'");
    }
}

#pragma mark == 成功连接外设 ==
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {

    if (self.connectedPeripheral) {
        
        return;
    }
    
    /**
     *  设置外设代理
     */
    _connectedPeripheral=peripheral;
    [peripheral setDelegate:self];
    
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didConnectPeripheral:)]) {
        
        [self.clientCallbackDelegate didConnectPeripheral:peripheral];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didConnectPeripheral:'");
    }
    //自动检索服务
    self.discoverServicesWithConnectedPeripheral ();
}

#pragma mark == 连接外设失败 ==
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {

    if ([self.clientCallbackDelegate respondsToSelector:@selector(didFailToConnectPeripheral:error:)]) {
        
        [self.clientCallbackDelegate didFailToConnectPeripheral:peripheral error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didFailToConnectPeripheral:error:'");
    }
}

#pragma mark == 外设断开连接 ==
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if ([self.connectedPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        
        _connectedPeripheral=nil;
    }
    
    //验证通知
    [[NSNotificationCenter defaultCenter] postNotificationName:BLEVerifyPeripheralDisconnect object:_verifyModel];
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didDisconnectPeripheral:error:)]) {
        
        [self.clientCallbackDelegate didDisconnectPeripheral:peripheral error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didDisconnectPeripheral:error:'");
    }
}

#pragma mark - 外设回调方法

#pragma mark == 检索外设服务回调 ==
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    //自动检索特征
    self.discoverCharacteristicsWithConnectedPeripheral ();
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didDiscoverServices:)]) {
        
        [self.clientCallbackDelegate didDiscoverServices:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didDiscoverServices:'");
    }
}



#pragma mark == 检索外设特征回调 ==
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {

    if ([peripheral.services.lastObject isEqual:service]) {
        
        //特征检索完成通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BLEVerifyCharacterDiscoverCompelete object:_verifyModel];
    }
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didDiscoverCharacteristicsForService:error:)]) {
        
        [self.clientCallbackDelegate didDiscoverCharacteristicsForService:service error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didDiscoverCharacteristicsForService:error:'");
    }
}



#pragma mark == 读取到特征值以及获取到通知 ==
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    
    
    if ([characteristic.service.UUID.UUIDString isEqualToString:VerifyServiceUUID]) {
        
        if ([characteristic.UUID.UUIDString isEqualToString:VerifySuccedCharacteristicUUID] || [characteristic.UUID.UUIDString isEqualToString:VerifyWriteCharacteristicUUID]) {
            
            if (characteristic.value.length) {
                
                NSData *data = [NSData dataWithData:characteristic.value];
                NSDictionary *valueDict = @{@"verify.value": data};
                NSString *noteName = [NSString stringWithFormat:@"verify.value.%@.%@",characteristic.service.UUID.UUIDString,characteristic.UUID.UUIDString];
                [[NSNotificationCenter defaultCenter] postNotificationName:noteName object:_verifyModel userInfo:valueDict];
                return;
            }
        }
    }
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didUpdateValueForCharacteristic:error:)]) {
        
        [self.clientCallbackDelegate didUpdateValueForCharacteristic:characteristic error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didUpdateValueForCharacteristic:error:'");
    }
}


#pragma mark == 特征值写入数据回调 ==
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didWriteValueForCharacteristic:error:)]) {
        
        [self.clientCallbackDelegate didWriteValueForCharacteristic:characteristic error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didWriteValueForCharacteristic:error:'");
    }
}

#pragma mark == 更新特征通知状态 ==
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    [[NSNotificationCenter defaultCenter] postNotificationName:BLEVerifyCharacteristicUpdateState object:_verifyModel];
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didUpdateNotificationStateForCharacteristic:error:)]) {
        
        [self.clientCallbackDelegate didUpdateNotificationStateForCharacteristic:characteristic error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didUpdateNotificationStateForCharacteristic:error:'");
    }
}

#pragma mark == 检索描述者回调 ==
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didDiscoverDescriptorsForCharacteristic:error:)]) {
        
            [self.clientCallbackDelegate didDiscoverDescriptorsForCharacteristic:characteristic error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didDiscoverDescriptorsForCharacteristic:error:'");
    }
}

#pragma mark == 读取描述者数据回调 ==
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didUpdateValueForDescriptor:error:)]) {
        
        [self.clientCallbackDelegate didUpdateValueForDescriptor:descriptor error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didUpdateValueForDescriptor:error:'");
    }
}

#pragma mark == 向描述者写入数据回调 ==
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
    if ([self.clientCallbackDelegate respondsToSelector:@selector(didWriteValueForDescriptor:error:)]) {
        
        [self.clientCallbackDelegate didWriteValueForDescriptor:descriptor error:error];
    }
    else {
        
        NSLog(@">>clientCallbackDelegate not response SEL 'didWriteValueForDescriptor:error:'");
    }
}

#pragma mark == 读取到外设RSSI数据 iOS version 7.0 ==
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (IOS_VERSION < 8.0 && IOS_VERSION > 5.0) {
        
        NSNumber *rssi = peripheral.RSSI;
        
        if ([self.clientCallbackDelegate respondsToSelector:@selector(didReadRSSI:error:)]) {
            
            [self.clientCallbackDelegate didReadRSSI:rssi error:error];
        }
        else {
            
            NSLog(@">>clientCallbackDelegate not response SEL 'didReadRSSI:error:'");
        }
    }
}


#pragma mark == 读取到外设RSSI数据 iOS verison 8.0 ==
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    
    if (IOS_VERSION >= 8.0) {
        
        if ([self.clientCallbackDelegate respondsToSelector:@selector(didReadRSSI:error:)]) {
            
            [self.clientCallbackDelegate didReadRSSI:RSSI error:error];
        }
        else {
            
            NSLog(@">>clientCallbackDelegate not response SEL 'didReadRSSI:error:'");
        }
    }
}



@end
