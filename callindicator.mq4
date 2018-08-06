
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
   if (candle1>0 && candle2<=0){
      ObjectCreate("er"+haOpen1,OBJ_ARROW_UP, 0, Time[0], Low[0]);
   }

   if (candle1<0 && candle2>=0){
      ObjectCreate("as"+haOpen1,OBJ_ARROW_DOWN, 0, Time[0], Low[0]);
   } 
 
 
   
  

   return;   
  }
