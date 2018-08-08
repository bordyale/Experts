
   
   
   double stopLossBUY;
   double stopLossSELL;   




void OnTick(void) 
  {
  
   double haOpen[5];
   double haClose[5];
   double haHighLow[5];
   double haLowHigh[5];
  
  
   haOpen[1] = GlobalVariableGet("haOpen1");
   haClose[1] = GlobalVariableGet("haClose1");
   haHighLow[1] = GlobalVariableGet("haHighLow1");
   haLowHigh[1] = GlobalVariableGet("haLowHigh1");
   
   haOpen[2] = GlobalVariableGet("haOpen2");
   haClose[2] = GlobalVariableGet("haClose2");
   haHighLow[2] = GlobalVariableGet("haHighLow2");
   haLowHigh[2] = GlobalVariableGet("haLowHigh2");
   
   haOpen[3] = GlobalVariableGet("haOpen3");
   haClose[3] = GlobalVariableGet("haClose3");
   haHighLow[3] = GlobalVariableGet("haHighLow3");
   haLowHigh[3] = GlobalVariableGet("haLowHigh3");
 
   haOpen[4] = GlobalVariableGet("haOpen4");
   haClose[4] = GlobalVariableGet("haClose4");
   haHighLow[4] = GlobalVariableGet("haHighLow4");
   haLowHigh[4] = GlobalVariableGet("haLowHigh4");
 
   
   double ema5 = iMA(NULL,0,5,3,MODE_EMA,PRICE_CLOSE,1);
   
   Print("****ema5: ",ema5);
   
   Print("******ha 1 - ",haOpen[1]," - ",haClose[1]," - ",haHighLow[1]," - ", haLowHigh[1]);
   Print("******ha 2 - ",haOpen[2]," - ",haClose[2]," - ",haHighLow[2]," - ", haLowHigh[2]);  
   
   //candle1 = 1 bullish candle
   //candle1 = 0 neutral candle   
   //candle1 = -1 bearish candle
   int haColour[5]={0,0,0,0,0};
   
   //defineHeikenAshiColour(candle1,candle2,candle3,candle4);
   if ((haOpen[1] - haClose[1])>0){
      Print("candle 1 down",haColour[1]," - ",haColour[2]);
      haColour[1]=-1;
   }
   if ((haOpen[1] - haClose[1])<0){
      Print("candle 1 up",haColour[1]," - ",haColour[2]);
      haColour[1]=1;
   }
 
   if ((haOpen[2] - haClose[2])>0){
      Print("candle 2 down");
      haColour[2]=-1;
   }
   if ((haOpen[2] - haClose[2])<0){
      Print("candle 2 up");
      haColour[2]=1;
   }  

   if ((haOpen[3] - haClose[3])>0){
      Print("candle 3 down");
      haColour[3]=-1;
   }
   if ((haOpen[3] - haClose[3])<0){
      Print("candle 3 up");
      haColour[3]=1;
   }  
   
   if ((haOpen[4] - haClose[4])>0){
      Print("candle 4 down");
      haColour[4]=-1;
   }
   if ((haOpen[4] - haClose[4])<0){
      Print("candle 4 up");
      haColour[4]=1;
   }  
   
   
   //close trades if change HA colour
   if (haColour[2]<=0 && haColour[1]>0){
      int openTrades = checkOpenTrade();
      if (openTrades < 1){
         int close =CloseAll();
      }
   }
   
   if (haColour[2]>=0 && haColour[1]<0){
      openTrades = checkOpenTrade();
      if (openTrades > -1){
         close =CloseAll();
      }
   }
   
   
   
   
   
   
   //check trade
   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL)+1000;
   Print("Minimum Stop Level=",minstoplevel," points");
   
   //open buy trade and close all trades
   if (haColour[2]<=0 && haColour[1]>0  && Close[1]>ema5 && isBUYPattern(haOpen, haClose, haHighLow, haLowHigh, haColour)){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour);
      Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      openBuyTrade(minstoplevel);
      return;     
   }
   if  (haColour[3]<=0 && haColour[2]>0 && haColour[1]>0  && Close[1]>ema5 && isBUYPattern(haOpen, haClose, haHighLow, haLowHigh, haColour)){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour);
      Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      openBuyTrade(minstoplevel);
      return;   
   }
   if (haColour[4]<=0 && haColour[3]>0 && haColour[2]>0  && haColour[1]>0  && Close[1]>ema5 && isBUYPattern(haOpen, haClose, haHighLow, haLowHigh, haColour)){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour);
      Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      openBuyTrade(minstoplevel);
      return;        
   }   
   
   
   
   

   //open sell trade and close all trades
   if (haColour[2]>=0 && haColour[1]<0 && Close[1]<ema5 && isSELLPattern(haOpen, haClose, haHighLow, haLowHigh, haColour)){
      //ObjectCreate("as"+haOpen1,OBJ_ARROW_DOWN, 0, Time[0], Low[0]);
      defineStopLoss(haColour);
      Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      openSellTrade(minstoplevel);
      return;
   } 
    if (haColour[3]>=0 && haColour[2]<0 && haColour[1]<0 && Close[1]<ema5 && isSELLPattern(haOpen, haClose, haHighLow, haLowHigh, haColour)){
      //ObjectCreate("as"+haOpen1,OBJ_ARROW_DOWN, 0, Time[0], Low[0]);
      defineStopLoss(haColour);
      Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      openSellTrade(minstoplevel);
      return;
   } 
    if (haColour[4]>=0 && haColour[3]<0 && haColour[2]<0 && haColour[1]<0 && Close[1]<ema5 && isSELLPattern(haOpen, haClose, haHighLow, haLowHigh, haColour)){
      //ObjectCreate("as"+haOpen1,OBJ_ARROW_DOWN, 0, Time[0], Low[0]);
      defineStopLoss(haColour);
      Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      openSellTrade(minstoplevel);
      return;
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



void defineStopLoss(int haColour[]){

   if (haColour[2]<=0 && haColour[1]>0){
      stopLossBUY= MathMin(Low[1],Low[2]);
   }
   
   if (haColour[2]>=0 && haColour[1]<0){
      stopLossSELL= MathMax(High[1],High[2]);
   }

   return;
}

void openBuyTrade(double minstoplevel){

      int openTrades = checkOpenTrade();
      if (openTrades < 1){
         int close =0;
         if (close==0){
            double price=Ask;
            //--- calculated SL and TP prices must be normalized
               double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
               double takeprofit=NormalizeDouble(Bid+minstoplevel*15*Point,Digits);
            //--- place market order to buy 1 lot
               int ticket=OrderSend(Symbol(),OP_BUY,0.1,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
         }
      }
      return;

}


void openSellTrade(double minstoplevel){

   int openTrades = checkOpenTrade();
      if (openTrades > -1){
         int close =0;
         if (close==0){
            double price=Bid;
            //--- calculated SL and TP prices must be normalized
               double stoploss=NormalizeDouble(Ask+minstoplevel*Point,Digits);
               double takeprofit=NormalizeDouble(Ask-minstoplevel*15*Point,Digits);
            //--- place market order to buy 1 lot
               int ticket=OrderSend(Symbol(),OP_SELL,0.1,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen);
         }
      }


}

bool isSELLPattern(double haOpen[], double haClose[], double haHighLow[], double haLowHigh[], int haColour[]){

   //return true;

   bool result = false;
   if ((Close[1]<=Close[2])&&
      (haOpen[1]>=haLowHigh[1])){
      result = true;
   }
   return result;

}


bool isBUYPattern(double haOpen[], double haClose[], double haHighLow[], double haLowHigh[], int haColour[]){
   
   //return true;
   
   bool result = false;
   if ((Close[1]>=Close[2])&&
      (haOpen[1]<=haLowHigh[1])){
      result = true;
   }
   return result;


}