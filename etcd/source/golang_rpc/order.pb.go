// Code generated by protoc-gen-go. DO NOT EDIT.
// source: order.proto

package main

import (
	fmt "fmt"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

type OrderRequest struct {
	OrderId              string   `protobuf:"bytes,1,opt,name=orderId,proto3" json:"orderId,omitempty"`
	TimeStamp            int64    `protobuf:"varint,2,opt,name=timeStamp,proto3" json:"timeStamp,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *OrderRequest) Reset()         { *m = OrderRequest{} }
func (m *OrderRequest) String() string { return proto.CompactTextString(m) }
func (*OrderRequest) ProtoMessage()    {}
func (*OrderRequest) Descriptor() ([]byte, []int) {
	return fileDescriptor_cd01338c35d87077, []int{0}
}

func (m *OrderRequest) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_OrderRequest.Unmarshal(m, b)
}
func (m *OrderRequest) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_OrderRequest.Marshal(b, m, deterministic)
}
func (m *OrderRequest) XXX_Merge(src proto.Message) {
	xxx_messageInfo_OrderRequest.Merge(m, src)
}
func (m *OrderRequest) XXX_Size() int {
	return xxx_messageInfo_OrderRequest.Size(m)
}
func (m *OrderRequest) XXX_DiscardUnknown() {
	xxx_messageInfo_OrderRequest.DiscardUnknown(m)
}

var xxx_messageInfo_OrderRequest proto.InternalMessageInfo

func (m *OrderRequest) GetOrderId() string {
	if m != nil {
		return m.OrderId
	}
	return ""
}

func (m *OrderRequest) GetTimeStamp() int64 {
	if m != nil {
		return m.TimeStamp
	}
	return 0
}

type OrderInfo struct {
	OrderId              string   `protobuf:"bytes,1,opt,name=OrderId,json=orderId,proto3" json:"OrderId,omitempty"`
	OrderName            string   `protobuf:"bytes,2,opt,name=OrderName,json=orderName,proto3" json:"OrderName,omitempty"`
	OrderStatus          string   `protobuf:"bytes,3,opt,name=OrderStatus,json=orderStatus,proto3" json:"OrderStatus,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *OrderInfo) Reset()         { *m = OrderInfo{} }
func (m *OrderInfo) String() string { return proto.CompactTextString(m) }
func (*OrderInfo) ProtoMessage()    {}
func (*OrderInfo) Descriptor() ([]byte, []int) {
	return fileDescriptor_cd01338c35d87077, []int{1}
}

func (m *OrderInfo) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_OrderInfo.Unmarshal(m, b)
}
func (m *OrderInfo) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_OrderInfo.Marshal(b, m, deterministic)
}
func (m *OrderInfo) XXX_Merge(src proto.Message) {
	xxx_messageInfo_OrderInfo.Merge(m, src)
}
func (m *OrderInfo) XXX_Size() int {
	return xxx_messageInfo_OrderInfo.Size(m)
}
func (m *OrderInfo) XXX_DiscardUnknown() {
	xxx_messageInfo_OrderInfo.DiscardUnknown(m)
}

var xxx_messageInfo_OrderInfo proto.InternalMessageInfo

func (m *OrderInfo) GetOrderId() string {
	if m != nil {
		return m.OrderId
	}
	return ""
}

func (m *OrderInfo) GetOrderName() string {
	if m != nil {
		return m.OrderName
	}
	return ""
}

func (m *OrderInfo) GetOrderStatus() string {
	if m != nil {
		return m.OrderStatus
	}
	return ""
}

func init() {
	proto.RegisterType((*OrderRequest)(nil), "main.OrderRequest")
	proto.RegisterType((*OrderInfo)(nil), "main.OrderInfo")
}

func init() { proto.RegisterFile("order.proto", fileDescriptor_cd01338c35d87077) }

var fileDescriptor_cd01338c35d87077 = []byte{
	// 150 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0xe2, 0xe2, 0xce, 0x2f, 0x4a, 0x49,
	0x2d, 0xd2, 0x2b, 0x28, 0xca, 0x2f, 0xc9, 0x17, 0x62, 0xc9, 0x4d, 0xcc, 0xcc, 0x53, 0x72, 0xe3,
	0xe2, 0xf1, 0x07, 0x09, 0x06, 0xa5, 0x16, 0x96, 0xa6, 0x16, 0x97, 0x08, 0x49, 0x70, 0xb1, 0x83,
	0x15, 0x79, 0xa6, 0x48, 0x30, 0x2a, 0x30, 0x6a, 0x70, 0x06, 0xc1, 0xb8, 0x42, 0x32, 0x5c, 0x9c,
	0x25, 0x99, 0xb9, 0xa9, 0xc1, 0x25, 0x89, 0xb9, 0x05, 0x12, 0x4c, 0x0a, 0x8c, 0x1a, 0xcc, 0x41,
	0x08, 0x01, 0xa5, 0x54, 0x2e, 0x4e, 0xb0, 0x39, 0x9e, 0x79, 0x69, 0xf9, 0x20, 0x43, 0xfc, 0x71,
	0x1a, 0x02, 0x96, 0xf1, 0x4b, 0xcc, 0x4d, 0x05, 0x1b, 0xc2, 0x19, 0xc4, 0x99, 0x0f, 0x13, 0x10,
	0x52, 0xe0, 0xe2, 0x06, 0xcb, 0x06, 0x97, 0x24, 0x96, 0x94, 0x16, 0x4b, 0x30, 0x83, 0xe5, 0x21,
	0x8e, 0x86, 0x08, 0x25, 0xb1, 0x81, 0xdd, 0x6e, 0x0c, 0x08, 0x00, 0x00, 0xff, 0xff, 0x0b, 0x39,
	0x91, 0x11, 0xca, 0x00, 0x00, 0x00,
}
