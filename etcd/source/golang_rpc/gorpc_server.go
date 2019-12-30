package main
import(
	"net/rpc"
	"math"
	"net"
	"net/http"
	"fmt"
	"time"
)

type MathUtil struct {
	
}

func (mu *MathUtil) CalcCircleArea(req float32, rsp *float32) error {
	*rsp = math.Pi * req * req
	return nil
}

func (mu *MathUtil) Add(req Param, rsp *int) error {
	*rsp = req.Param1 + req.Param2
	return nil
}

func (mu *MathUtil)GetOrderInfo(req OrderRequest, rsp *OrderInfo)error{
	orderMap := map[string]OrderInfo {
		"001" : OrderInfo{ OrderId: "001", OrderName: "衣服", OrderStatus : "已付款"},
		"002" : OrderInfo{ OrderId: "002", OrderName: "零食", OrderStatus : "已付款"},
		"003" : OrderInfo{ OrderId: "003", OrderName: "手机", OrderStatus : "未付款"},
	}
	currentTime := time.Now().Unix()
	if req.TimeStamp > currentTime {
		return fmt.Errorf("time expired")
	}
	
	order, ok := orderMap[req.OrderId]
	if !ok {
		return fmt.Errorf("Not found this order")
	}
	*rsp = order
	fmt.Print("GetOrderInfo", req, rsp)
	return nil
}
func main(){
	mathUtil := new(MathUtil)
	err := rpc.Register(mathUtil)
	if err != nil {
		fmt.Println("Regist rpc fail")
		return
	}
	
	rpc.HandleHTTP()
	
	listen, err := net.Listen("tcp", ":8881")
	http.Serve(listen, nil)
}