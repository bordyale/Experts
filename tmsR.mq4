
datetime LastActiontime;

   double stopLossBUY;
   double stopLossSELL;   
   
 
   
   datetime candleOpenTrade;
   input color           InpColor=clrBlue; 
   input int             InpPrice=25;         // Line price, %
   

int OnInit()
  {


   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {

   
  }




void OnTick(void) 
  {
   double haOpen[5];
   double haClose[5];
   double haHighLow[5];
   double haLowHigh[5];
   double hma[5];  
  
   haOpen[0] = GlobalVariableGet("haOpen0");
   haClose[0] = GlobalVariableGet("haClose0");
   haHighLow[0] = GlobalVariableGet("haHighLow0");
   haLowHigh[0] = GlobalVariableGet("haLowHigh0");
   hma[0]=GlobalVariableGet("hma0");
  
   haOpen[1] = GlobalVariableGet("haOpen1");
   haClose[1] = GlobalVariableGet("haClose1");
   haHighLow[1] = GlobalVariableGet("haHighLow1");
   haLowHigh[1] = GlobalVariableGet("haLowHigh1");
   hma[1]=GlobalVariableGet("hma1");
   
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
 
   
   double ema5 = iMA(NULL,0,5,2,MODE_EMA,PRICE_CLOSE,1);

   double ema20 = iMA(NULL,0,5,3,MODE_EMA,PRICE_CLOSE,1);
   
   
   //Print("******ha 1 - ",haOpen[1]," - ",haClose[1]," - ",haHighLow[1]," - ", haLowHigh[1]);
   //Print("******ha 2 - ",haOpen[2]," - ",haClose[2]," - ",haHighLow[2]," - ", haLowHigh[2]);  
   
   //candle1 = 1 bullish candle
   //candle1 = 0 neutral candle   
   //candle1 = -1 bearish candle
   int haColour[5]={0,0,0,0,0};
   
   //defineHeikenAshiColour(candle1,candle2,candle3,candle4);
   if ((haOpen[0] - haClose[0])>0){
     // Print("candle 0 down",haColour[0]," - ",haColour[1]);
      haColour[0]=-1;
   }
   if ((haOpen[0] - haClose[0])<0){
   //Print("candle 0 up",haColour[0]," - ",haColour[1]);
      haColour[0]=1;
   }
   if ((haOpen[1] - haClose[1])>0){
      //Print("candle 1 down",haColour[1]," - ",haColour[2]);
      haColour[1]=-1;
   }
   if ((haOpen[1] - haClose[1])<0){
      //Print("candle 1 up",haColour[1]," - ",haColour[2]);
      haColour[1]=1;
   }
 
   if ((haOpen[2] - haClose[2])>0){
      //Print("candle 2 down");
      haColour[2]=-1;
   }
   if ((haOpen[2] - haClose[2])<0){
      //Print("candle 2 up");
      haColour[2]=1;
   }  

   if ((haOpen[3] - haClose[3])>0){
      //Print("candle 3 down");
      haColour[3]=-1;
   }
   if ((haOpen[3] - haClose[3])<0){
      //Print("candle 3 up");
      haColour[3]=1;
   }  
   
   if ((haOpen[4] - haClose[4])>0){
      //Print("candle 4 down");
      haColour[4]=-1;
   }
   if ((haOpen[4] - haClose[4])<0){
      //Print("candle 4 up");
      haColour[4]=1;
   }  
   //Print("haOpen: " + haOpen[1] + " haClose: " + haClose[1] + " haHighLow: " + haHighLow[1] + " haLowHigh: " + haLowHigh[1] + " haColour: "  + haColour[1]);   
   
   //close trades if change HA colour
   
   //Print("This code is executed only once in the bar started ",Time[0]);
   if ( Bid > MathMax(MathMax(haLowHigh[1],haHighLow[1]),MathMax(haOpen[1],haClose[1]))){
      int openTrades = checkOpenTrade();
      if (openTrades == -1){
         Print("**** Close Sell trades: ", haColour[1], " --- ", candleOpenTrade, " --- ", Time[0], " --- ", MathMax(MathMax(haLowHigh[1],haHighLow[1]),MathMax(haOpen[1],haClose[1])), " --- ", Bid);
        // printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         int close =CloseSell();
      }
    }
   
   if (Ask < MathMin(MathMin(haLowHigh[1],haHighLow[1]),MathMin(haOpen[1],haClose[1]))){
      openTrades = checkOpenTrade();
      if (openTrades == 1){
        Print("**** Close Buy trades ", haColour[1], " - ", haColour[0], " - ", Time[0]," --- ", MathMin(MathMin(haLowHigh[1],haHighLow[1]),MathMin(haOpen[1],haClose[1])), " --- ", Ask);
        //printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         close =CloseBuy();
      }
   }
   
   
      
     // LastActiontime=Time[0];
  // }
   /*if (haColour[1]<=0 && Bid > MathMax(haLowHigh[1],haOpen[1])){
      if(checkOpenTrade()==-1){
         CloseSell();
      }
      
   }
   if (haColour[1]>=0 && Bid > MathMax(haHighLow[1],haClose[1])){
      if(checkOpenTrade()==-1){
         CloseSell();
      }
   }
   
   if (haColour[1]>=0 && Ask < MathMin(haLowHigh[1],haOpen[1])){
       if(checkOpenTrade()==1){
         CloseBuy();
      }
   }
   if (haColour[1]<=0 && Ask < MathMin(haHighLow[1],haClose[1])){
      if(checkOpenTrade()==1){
         CloseBuy();
      }
   }*/
   
   
   
   double line1 = ObjectGet("line1",OBJPROP_PRICE1);
   
   //check trade
   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL)+1000;
   //Print("Minimum Stop Level=",minstoplevel," points");
   
   //RefreshRates();
   /*
   if (haColour[1]<=0 && Bid > haLowHigh[1] && Bid > ema5 && Bid > ema20){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour[2],haColour[1]);
      //Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
     
      openBuyTrade(minstoplevel);
      return;     
   }
   if (haColour[1]>=0 && Bid > haHighLow[1] && Bid > ema5 && Bid > ema20){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour[2],haColour[1]);
      //Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
    
      openBuyTrade(minstoplevel);
      return;     
   }

   if (haColour[1]>=0 && Ask < haLowHigh[1] && Ask < ema5 && Ask < ema20){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour[2],haColour[1]);
      //Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
     
      openSellTrade(minstoplevel);
      return;     
   }
   if (haColour[1]<=0 && Ask < haHighLow[1] && Ask < ema5 && Ask < ema20){
      //ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
      defineStopLoss(haColour[2],haColour[1]);
      //Print("**** StopLoss: ", stopLossBUY, " - ", stopLossSELL);
      
      openSellTrade(minstoplevel);
      return;     
   }   */   
   if(isNewBar()){
     Print("Inizio candela");
     Print("hma0: ", hma[0], "hma1: ", hma[1],"****ema5: ",ema5);
     //printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
     //printHA(0,haOpen, haClose, haHighLow, haLowHigh, haColour);
    if (haColour[1]<=0 && haColour[0]>0  && Close[1]>ema5 && hma[0]>ema5  ){ 
      if(checkOpenTrade()==0){
         //printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         defineStopLoss(haColour[1],haColour[0]);
         openBuyTrade(minstoplevel);
      }
      return;     
   }
   if (haColour[2]<=0 && haColour[1]>0 && haColour[0]>0  && Close[1]>ema5 && hma[0]>ema5  ){
      if(checkOpenTrade()==0){
      //printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         defineStopLoss(haColour[2],haColour[1]);
         openBuyTrade(minstoplevel);
      }
      return;     
   }
   if (haColour[3]<=0 && haColour[2]>0 && haColour[1]>0  && haColour[0]>0  && Close[1]>ema5 && hma[0]>ema5  ){
      if(checkOpenTrade()==0){
     // printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         defineStopLoss(haColour[3],haColour[2]);
         openBuyTrade(minstoplevel);
      }
      return;     
   }
   
   
   
   if (haColour[1]>=0 && haColour[0]<0 && Close[1]<ema5 && hma[0]<ema5 ){
      if(checkOpenTrade()==0){
     // printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         defineStopLoss(haColour[1],haColour[0]);
         openSellTrade(minstoplevel);
      }
      return;     
   } 
   if (haColour[2]>=0 && haColour[1]<0 && haColour[0]<0 && Close[1]<ema5 && hma[0]<ema5  ){
      if(checkOpenTrade()==0){
     // printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         defineStopLoss(haColour[2],haColour[1]);
         openSellTrade(minstoplevel);
      }
      return;     
   } 
   if (haColour[3]>=0 && haColour[2]<0 && haColour[1]<0 && haColour[0]<0 && Close[1]<ema5 && hma[0]<ema5 ){
      if(checkOpenTrade()==0){
    //  printHA(1,haOpen, haClose, haHighLow, haLowHigh, haColour);
         defineStopLoss(haColour[3],haColour[2]);
         openSellTrade(minstoplevel);
      }
      return;     
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

int CloseBuy()
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
      case OP_SELL      : 
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

int CloseSell()
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
      case OP_BUY       :       
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





void defineStopLoss(int haColour2, int haColour1){

   if (haColour2<=0 && haColour1>0){
      stopLossBUY= MathMin(Low[1],Low[2])- 100 * Point;
   }
   
   if (haColour2>=0 && haColour1<0){
      stopLossSELL= MathMax(High[1],High[2]) + 100 * Point;
   }

   return;
}

void openBuyTrade(double minstoplevel){

      Print("Open Buy trade");
      
      int openTrades = checkOpenTrade();
      if (openTrades == 0){
         int close =0;
         if (close==0){
            double price=Ask;
            //--- calculated SL and TP prices must be normalized
               double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
               double takeprofit=NormalizeDouble(Bid+minstoplevel*15*Point,Digits);
            //--- place market order to buy 1 lot
               int ticket=OrderSend(Symbol(),OP_BUY,0.1,price,3,stopLossBUY,takeprofit,"My order",16384,0,clrGreen);
               candleOpenTrade = Time[0];
         }
      }
      return;

}


void openSellTrade(double minstoplevel){
   
   Print("Open Sell trade");

   int openTrades = checkOpenTrade();
      if (openTrades == 0){
         int close =0;
         if (close==0){
            double price=Bid;
            //--- calculated SL and TP prices must be normalized
               double stoploss=NormalizeDouble(Ask+minstoplevel*Point,Digits);
               double takeprofit=NormalizeDouble(Ask-minstoplevel*15*Point,Digits);
            //--- place market order to buy 1 lot
               int ticket=OrderSend(Symbol(),OP_SELL,0.1,price,3,stopLossSELL,takeprofit,"My order",16384,0,clrGreen);
               candleOpenTrade = Time[0];
         }
      }


}

bool isSELLPattern(double haOpen[], double haClose[], double haHighLow[], double haLowHigh[], int haColour[]){

   //return true;

   bool result = false;
   if (haOpen[0]>=haLowHigh[0] && Close[1]<Open[1]){
      result = true;
   }
   return result;

}


bool isBUYPattern(double haOpen[], double haClose[], double haHighLow[], double haLowHigh[], int haColour[]){
   
   //return true;
   
   bool result = false;
   if (haOpen[0]<=haLowHigh[0] && Close[1]>Open[1]){
      result = true;
   }
   return result;


}


bool isNewBar()
{
   static datetime lastbar;
   datetime curbar = Time[0];
   if(lastbar!=curbar)
   {
   lastbar=curbar;
   return (true);
   }
   else
   {
   return(false);
   }
}

bool isGoodBullCandle(int haIndex){
   





}

void printHA(int i,double haOpen[], double haClose[], double haHighLow[], double haLowHigh[], int haColour[]){
   
  Print("haOpen: " + haOpen[i] + " haClose: " + haClose[i] + " haHighLow: " + haHighLow[i] + " haLowHigh: " + haLowHigh[i] + " haColour: "  + haColour[i]);   
   
}