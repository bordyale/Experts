
void OnTick(void) 
  {
   double haOpen1 = GlobalVariableGet("haOpen1");
   double haClose1 = GlobalVariableGet("haClose1");
   double haHighLow1 = GlobalVariableGet("haHighLow1");
   double haLowHigh1 = GlobalVariableGet("haLowHigh1");
   
   double haOpen2 = GlobalVariableGet("haOpen2");
   double haClose2 = GlobalVariableGet("haClose2");
   double haHighLow2 = GlobalVariableGet("haHighLow2");
   double haLowHigh2 = GlobalVariableGet("haLowHigh2");
   
   
   //Print("******1 - ",haOpen1," - ",haClose1," - ",haHighLow1," - ", haLowHigh1);
   //Print("******2 - ",haOpen2," - ",haClose2," - ",haHighLow2," - ", haLowHigh2);  
   
   //candle1 = 1 bullish candle
   //candle1 = 0 neutral candle   
   //candle1 = -1 bearish candle
   int candle1 = 0;
   int candle2= 0;
   
   
   if ((haOpen1 - haClose1)>0){
      Print("candle 1 down",candle1," - ",candle2);
      candle1=-1;
   }
   if ((haOpen1 - haClose1)<0){
      Print("candle 1 up",candle1," - ",candle2);
      candle1=1;
   }
 
   if ((haOpen2 - haClose2)>0){
      Print("candle 2 down");
      candle2=-1;
   }
   if ((haOpen2 - haClose2)<0){
      Print("candle 2 up");
      candle2=1;
   }  
   
   //check trade
   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL)+1000;
   Print("Minimum Stop Level=",minstoplevel," points");
   
   //open buy trade and close all trades
   if (candle1>0 && candle2<=0){
      ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      int openTrades = checkOpenTrade();
      if (openTrades < 1){
         int close =CloseAll();
         if (close==0){
            double price=Ask;
            //--- calculated SL and TP prices must be normalized
               double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
               double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
            //--- place market order to buy 1 lot
               int ticket=OrderSend(Symbol(),OP_BUY,0.01,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
         }
      }
      
   }

   //open sell trade and close all trades
   if (candle1<0 && candle2>=0){
      ObjectCreate("as"+haOpen1,OBJ_ARROW_DOWN, 0, Time[0], Low[0]);
      openTrades = checkOpenTrade();
      if (openTrades > -1){
         close =CloseAll();
         if (close==0){
            price=Bid;
            //--- calculated SL and TP prices must be normalized
               stoploss=NormalizeDouble(Ask+minstoplevel*Point,Digits);
               takeprofit=NormalizeDouble(Ask-minstoplevel*Point,Digits);
            //--- place market order to buy 1 lot
               ticket=OrderSend(Symbol(),OP_SELL,0.01,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
         }
      }
   } 

   return;   
  }



int checkOpenTrade(){

  int total = OrdersTotal();
  int result = 0;
  for(int i=total-1;i>=0;i--)
  {
      OrderSelect(i, SELECT_BY_POS);
      int type   = OrderType();
  
    
       switch(type)
       {
         //Close opened long positions
         case OP_BUY       : result = 1;
                          break;
                             
         
         //Close opened short positions
         case OP_SELL      : result = -1;
                          break;
                             
   
         //Close pending orders
         case OP_BUYLIMIT  :
         case OP_BUYSTOP   :
         case OP_SELLLIMIT :
         case OP_SELLSTOP  : ;
       }
    
  }

   return(result);
   

}



int CloseAll()
{
  int total = OrdersTotal();
  for(int i=total-1;i>=0;i--)
  {
    OrderSelect(i, SELECT_BY_POS);
    int type   = OrderType();

    bool result = false;
    
    switch(type)
    {
      //Close opened long positions
      case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                          break;
      
      //Close opened short positions
      case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                          break;

      //Close pending orders
      case OP_BUYLIMIT  :
      case OP_BUYSTOP   :
      case OP_SELLLIMIT :
      case OP_SELLSTOP  : result = OrderDelete( OrderTicket() );
    }
    
    if(result == false)
    {
      Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
      return(1);
      Sleep(3000);
      
    }  
  }
  
  return(0);
}