
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
   
   double haOpen3 = GlobalVariableGet("haOpen3");
   double haClose3 = GlobalVariableGet("haClose3");
   double haHighLow3 = GlobalVariableGet("haHighLow3");
   double haLowHigh3 = GlobalVariableGet("haLowHigh3");
 
   double haOpen4 = GlobalVariableGet("haOpen4");
   double haClose4 = GlobalVariableGet("haClose4");
   double haHighLow4 = GlobalVariableGet("haHighLow4");
   double haLowHigh4 = GlobalVariableGet("haLowHigh4");
 
   
   double ema5 = iMA(NULL,0,5,3,MODE_EMA,PRICE_CLOSE,1);
   
   Print("****ema5: ",ema5);
   
   //Print("******1 - ",haOpen1," - ",haClose1," - ",haHighLow1," - ", haLowHigh1);
   //Print("******2 - ",haOpen2," - ",haClose2," - ",haHighLow2," - ", haLowHigh2);  
   
   //candle1 = 1 bullish candle
   //candle1 = 0 neutral candle   
   //candle1 = -1 bearish candle
   int candle1 = 0;
   int candle2= 0;
   int candle3= 0;
   int candle4= 0;   
   
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

   if ((haOpen3 - haClose3)>0){
      Print("candle 3 down");
      candle3=-1;
   }
   if ((haOpen3 - haClose3)<0){
      Print("candle 3 up");
      candle3=1;
   }  
   
   if ((haOpen4 - haClose4)>0){
      Print("candle 4 down");
      candle4=-1;
   }
   if ((haOpen4 - haClose4)<0){
      Print("candle 4 up");
      candle4=1;
   }  


   
   //check trade
   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL)+200;
   Print("Minimum Stop Level=",minstoplevel," points");
   
   //open buy trade and close all trades
   if ((candle2<=0 && candle1>0  && Close[1]>ema5) || 
      (candle3<=0 && candle2>0 && candle1>0  && Close[1]>ema5)|| 
      (candle4<=0 && candle3>0 && candle2>0  && candle1>0  && Close[1]>ema5)){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      int openTrades = checkOpenTrade();
      if (openTrades < 1){
         int close =CloseAll();
         if (close==0){
            double price=Ask;
            //--- calculated SL and TP prices must be normalized
               double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
               double takeprofit=NormalizeDouble(Bid+minstoplevel*5*Point,Digits);
            //--- place market order to buy 1 lot
               int ticket=OrderSend(Symbol(),OP_BUY,1,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
         }
      }
      
   }

   //open sell trade and close all trades
   if ((candle2>=0 && candle1<0 && Close[1]<ema5) ||
      (candle3>=0 && candle2<0 && candle1<0 && Close[1]<ema5) ||
      (candle4>=0 && candle3<0 && candle2<0 && candle1<0 && Close[1]<ema5)){
      //ObjectCreate("as"+haOpen1,OBJ_ARROW_DOWN, 0, Time[0], Low[0]);
      openTrades = checkOpenTrade();
      if (openTrades > -1){
         close =CloseAll();
         if (close==0){
            price=Bid;
            //--- calculated SL and TP prices must be normalized
               stoploss=NormalizeDouble(Ask+minstoplevel*Point,Digits);
               takeprofit=NormalizeDouble(Ask-minstoplevel*5*Point,Digits);
            //--- place market order to buy 1 lot
               ticket=OrderSend(Symbol(),OP_SELL,1,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
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