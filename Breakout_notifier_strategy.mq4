//+------------------------------------------------------------------+
//|                               Sanji                              |
//+------------------------------------------------------------------+

//VERSION 3:
//Ajout de " ou " pour un décalage de 2,3 et 4 pour l'ATR
//Réduction de la valeur de ATR et RSI

//VERSION 4:
//Changement du décalage de l'ATR (shift) à partir de 1(ATR now) jusqu'à 8 ou 5 ou 4.
//Verification avec valeurs de Dimitri: 100% OK.

//VERSION 5:
//Changement du décalage du RSI  partant à 1  jusqu'à 7.
//RSI >5 ou <-5   (avant 1 ou -1)

//VERSION 6:
//Changement du décalage de l'ATR ( entre la bougie qui casse et 2 avant : Donc "1" et "3")
//Condition de l'ATR > 0.00003
//Changement de condition du RSI:   RSI>65 ou RSI<35

#property version   "6.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Green
#property indicator_color4 clrRed 
#property indicator_color5 clrLawnGreen
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 3
#property indicator_width5 3

input int BarsToCount=20;

double     upper[];
double     middle[];
double     lower[];
double CrossUp[];
double CrossDown[];
double R1,R2,R3,R4,S1,S2,S3,S4,PP;
datetime time1,time2,time_now;

datetime NewCandleTime=TimeCurrent();


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
  IndicatorShortName("DCH("+IntegerToString(BarsToCount)+")");

   SetIndexBuffer(0,upper);
   SetIndexBuffer(1,middle);
   SetIndexBuffer(2,lower);
   SetIndexBuffer(3, CrossUp);
   SetIndexBuffer(4, CrossDown);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexStyle(4, DRAW_ARROW, EMPTY);
   
   SetIndexLabel(0,"Upper");
   SetIndexLabel(1,"Middle");  
   SetIndexLabel(2,"Lower");   
   
    
   SetIndexArrow(3, 225);
   SetIndexArrow(4, 226);   
//---
   return(INIT_SUCCEEDED);
}

bool IsNewCandle(){
 
   //If the time of the candle when the function last run
   //is the same as the time of the time this candle started
   //return false, because it is not a new candle
   if(NewCandleTime==iTime(Symbol(),0,0)) return false;
   
   //otherwise it is a new candle and return true
   else{
      //if it is a new candle then we store the new value
      NewCandleTime=iTime(Symbol(),0,0);
      return true;
   }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    
    


if(IsNewCandle()){

     
     int limit;
     int counted_bars=IndicatorCounted();
  //---- check for possible error
  //---- the last counted bar will be recounted
     if(counted_bars<1) counted_bars=1;
     limit=Bars-counted_bars;
     Comment("Bars total est ",Bars,"Bars compté est ",counted_bars,"La limite est",limit);
     
       //int limit = rates_total - prev_calculated;
   //if(prev_calculated > 0) limit++;
   
   
   
   for(int i=1; i < limit; i++)
   {
      
      upper[i]=iHigh(Symbol(),Period(),iHighest(Symbol(),PERIOD_M5,MODE_HIGH,BarsToCount,i));
      lower[i]=iLow(Symbol(),Period(),iLowest(Symbol(),PERIOD_M5,MODE_LOW,BarsToCount,i));
      middle[i] = (upper[i]+lower[i])/2;
      
//+------------------------------------------------------------------+
//| RECUPERATION DES VALEURS DE RSI POUR FAIRE SA MOYENNE MOBILE                         |
//+------------------------------------------------------------------+
      double RSI_1 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,1);
      double RSI_2 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,2);
      double RSI_3 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,3);
      double RSI_4 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,4);
      double RSI_5 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,5);
      double RSI_6 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,6);
      double RSI_7 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,7);
      double RSI_8 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,8);
      double RSI_9 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,9);
      double RSI_10 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,10);
      double RSI_11 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,11);
      double RSI_12 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,12);
      double RSI_13 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,13);
      double RSI_14 = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,14);

      double Moyenne_RSI = (RSI_3+RSI_4+RSI_5+RSI_6+RSI_7+RSI_8+RSI_9+RSI_10)/8;
      
//+------------------------------------------------------------------+
//| RSI PLUS HAUT ET PLUS BAS POUR FAIRE UN RANGE                    |
//+------------------------------------------------------------------+
     double diffRsiMaxMin_2_10 = calculateDeltaRsiMaxMin_2_10(RSI_1,RSI_2,RSI_3,RSI_4,RSI_5,RSI_6,RSI_7,RSI_8,RSI_9,RSI_10,RSI_11,RSI_12,RSI_13,RSI_14);
     double diffRsiMaxMin_3_10 = calculateDeltaRsiMaxMin_3_10(RSI_1,RSI_2,RSI_3,RSI_4,RSI_5,RSI_6,RSI_7,RSI_8,RSI_9,RSI_10,RSI_11,RSI_12,RSI_13,RSI_14);
     double diffRsiMaxMin_4_10 = calculateDeltaRsiMaxMin_4_10(RSI_1,RSI_2,RSI_3,RSI_4,RSI_5,RSI_6,RSI_7,RSI_8,RSI_9,RSI_10,RSI_11,RSI_12,RSI_13,RSI_14);
      
      
//+------------------------------------------------------------------+
//| FERMETURE BOUGIE AVEC DELTA DE RSI ET ATR                        |
//+------------------------------------------------------------------+
      double bougie = iClose(Symbol(),PERIOD_M5,0);
      double RSI_now = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,1);
      double RSI_avant = iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,4);
      double delta_RSI = RSI_now - RSI_avant;
      double pivot=calculateTodayClassic();
      
//+------------------------------------------------------------------+
//| FERMETURE BOUGIE AVEC DELTA DE RSI ET ATR                        |
//+------------------------------------------------------------------+      
      

      


//+------------------------------------------------------------------+
//| CONDITIONS CASSURE HAUSSIERE                                     |
//+------------------------------------------------------------------+
      
      if((bougie > upper[i+1]) && (RSI_now>60)  && ((diffRsiMaxMin_2_10<18) || (diffRsiMaxMin_3_10<18) || (diffRsiMaxMin_4_10<18)))
      {
         Print(time_now);
         //Print(diffRsiMaxMin_2_14,"      ",diffRsiMaxMin_3_14,"      ",diffRsiMaxMin_4_14);
         //Print(upper[i+10]);
         CrossDown[i]=High[i]+0.0001 ; 
         //Print(" RSI1: ", ceil(RSI_1) , " RSI2: ", ceil(RSI_2) , " RSI3: ", ceil(RSI_3) , " RSI4: ", ceil(RSI_4) , " RSI5: ", ceil(RSI_5) , " RSI6: ", ceil(RSI_6) , " RSI7: ", ceil(RSI_7) , " RSI8: ", ceil(RSI_8) , " RSI9: ", ceil(RSI_9) , " RSI10: ", ceil(RSI_10));
         //&& (RSI_now>60) && (RSI_now<70) && (RSI_2>48) && (RSI_2<64)&& (RSI_3>36) && (RSI_3<58) && (RSI_4>24) && (RSI_4<52) && (RSI_5>12) && (RSI_5<46) && (RSI_6>0) && (RSI_6<40))
         SendNotification((string)Symbol()+" Cassure Haussière !");
      
      }
      
//+------------------------------------------------------------------+
//| CONDITIONS CASSURE BAISSIERE                                     |
//+------------------------------------------------------------------+
         if((bougie < lower[i+1]) && (RSI_now<40) && ((diffRsiMaxMin_2_10<18) || (diffRsiMaxMin_3_10<18) || (diffRsiMaxMin_4_10<18)))
      {
         Print(time_now);
        //Print(diffRsiMaxMin_2_14,"      ",diffRsiMaxMin_3_14,"      ",diffRsiMaxMin_4_14);
        //Print(lower[i+10]);
         CrossUp[i]=Low[i]-0.0001 ;
          //Print(" RSI1: ", ceil(RSI_1) , " RSI2: ", ceil(RSI_2) , " RSI3: ", ceil(RSI_3) , " RSI4: ", ceil(RSI_4) , " RSI5: ", ceil(RSI_5) , " RSI6: ", ceil(RSI_6) , " RSI7: ", ceil(RSI_7) , " RSI8: ", ceil(RSI_8) , " RSI9: ", ceil(RSI_9) , " RSI10: ", ceil(RSI_10));
         SendNotification((string)Symbol()+" Cassure Baissière !");
         
      
      }
      
      
   }
   
   
  
   
   //old_bars = Bars;   
//--- return value of prev_calculated for next call
   }
   return(rates_total);
  
   
}

double calculateTodayClassic()
  {
   double prevRange= iHigh(Symbol(),1440,1)-iLow(Symbol(),1440,1);
   double prevHigh = iHigh(Symbol(),1440,1);
   double prevLow=iLow(Symbol(),1440,1);
   double prevClose=iClose(Symbol(),1440,1);
   PP = NormalizeDouble((prevHigh+prevLow+prevClose)/3,Digits);
   R1 = NormalizeDouble((PP * 2)-prevLow,Digits);
   R2 = NormalizeDouble(PP + prevRange,Digits);
   R3 = NormalizeDouble(R2 + prevRange,Digits);
   R4 = NormalizeDouble(R3 + prevRange,Digits);
   S1 = NormalizeDouble((PP * 2)-prevHigh,Digits);
   S2 = NormalizeDouble(PP - prevRange,Digits);
   S3 = NormalizeDouble(S2 - prevRange,Digits);
   S4 = NormalizeDouble(S3 - prevRange,Digits);
   time1 = iTime(Symbol(),1440,0);
   time2 = time1 + iTime(Symbol(),1440,0)-iTime(Symbol(),1440,1);
   return(PP);

  }

double calculateDeltaRsiMaxMin_2_10(double rsi1,double rsi2,double rsi3,double rsi4,double rsi5,double rsi6,double rsi7,double rsi8,double rsi9,double rsi10,double rsi11,double rsi12,double rsi13,double rsi14)
{
   double deltaRSI=0;
   double values_rsi[9];
   values_rsi[0] = rsi2;
   values_rsi[1] = rsi3;
   values_rsi[2] = rsi4;
   values_rsi[3] = rsi5;
   values_rsi[4] = rsi6;
   values_rsi[5] = rsi7;
   values_rsi[6] = rsi8;
   values_rsi[7] = rsi9;
   values_rsi[8] = rsi10;
   //values_rsi[9] = rsi11;
   //values_rsi[10] = rsi12;
   //values_rsi[11] = rsi13;
   //values_rsi[12] = rsi14;
   
   int maxIndex = ArrayMaximum(values_rsi,WHOLE_ARRAY,0);
   double max = values_rsi[maxIndex];
   
   int minIndex = ArrayMinimum(values_rsi,WHOLE_ARRAY,0);
   double min = values_rsi[minIndex];
   
   if((rsi1>rsi4+6) || (rsi1<rsi4-6))
   {
   deltaRSI = max - min;
   }
   else
   {
   deltaRSI=100;
   }
   return (deltaRSI);

}
double calculateDeltaRsiMaxMin_3_10(double rsi1,double rsi2,double rsi3,double rsi4,double rsi5,double rsi6,double rsi7,double rsi8,double rsi9,double rsi10,double rsi11,double rsi12,double rsi13,double rsi14)
{
   double deltaRSI=0;
   double values_rsi[8];
   values_rsi[0] = rsi3;
   values_rsi[1] = rsi4;
   values_rsi[2] = rsi5;
   values_rsi[3] = rsi6;
   values_rsi[4] = rsi7;
   values_rsi[5] = rsi8;
   values_rsi[6] = rsi9;
   values_rsi[7] = rsi10;
   //values_rsi[8] = rsi11;
   //values_rsi[9] = rsi12;
   //values_rsi[10] = rsi13;
   //values_rsi[11] = rsi14;
   
   int maxIndex = ArrayMaximum(values_rsi,WHOLE_ARRAY,0);
   double max = values_rsi[maxIndex];
   
   int minIndex = ArrayMinimum(values_rsi,WHOLE_ARRAY,0);
   double min = values_rsi[minIndex];
   
    if((rsi1>rsi4+6) || (rsi1<rsi4-6))
   {
   deltaRSI = max - min;
   }
   else
   {
   deltaRSI=100;
   }
   return (deltaRSI);

}

double calculateDeltaRsiMaxMin_4_10(double rsi1,double rsi2,double rsi3,double rsi4,double rsi5,double rsi6,double rsi7,double rsi8,double rsi9,double rsi10,double rsi11,double rsi12,double rsi13,double rsi14)
{
   double deltaRSI=0;
   double values_rsi[7];
   values_rsi[0] = rsi4;
   values_rsi[1] = rsi5;
   values_rsi[2] = rsi6;
   values_rsi[3] = rsi7;
   values_rsi[4] = rsi8;
   values_rsi[5] = rsi9;
   values_rsi[6] = rsi10;
   //values_rsi[7] = rsi11;
   //values_rsi[8] = rsi12;
   //values_rsi[9] = rsi13;
   //values_rsi[10] = rsi14;
   
   int maxIndex = ArrayMaximum(values_rsi,WHOLE_ARRAY,0);
   double max = values_rsi[maxIndex];
   
   int minIndex = ArrayMinimum(values_rsi,WHOLE_ARRAY,0);
   double min = values_rsi[minIndex];
   
    if((rsi1>rsi4+6) || (rsi1<rsi4-6))
   {
   deltaRSI = max - min;
   }
   else
   {
   deltaRSI=100;
   }
   return (deltaRSI);
   

}
//+------------------------------------------------------------------+