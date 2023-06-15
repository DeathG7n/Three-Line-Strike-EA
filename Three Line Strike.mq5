#include <Trade\Trade.mqh>

CTrade trade;
int ma21Handle, ma50Handle, ma200Handle;
double ma21[], ma50[], ma200[];
double fastMa, middleMa, slowMa;
int rsiHandle;
double rsiArray[], rsi;
int fractalhandle;
double upperFractalArray[], lowerFractalArray[];
double upperFractal, lowerFractal;
bool isBullish, isBullish2, isBullish3, isBullish4;
bool isEngulfing;
int barsTotal;
int positionTotal;
bool isUptrend;
input double lotSize = 0.01;
string signal;
bool candleClosed;
input int threshold = 10;
double stopLoss, takeProfit;

int OnInit(){
   barsTotal = iBars(_Symbol,PERIOD_CURRENT);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){

   
  }

void OnTick(){
     //Get the 21 peroid moving average
     ma21Handle = iMA(_Symbol,PERIOD_CURRENT,21,0,MODE_SMMA,PRICE_CLOSE);
     CopyBuffer(ma21Handle,MAIN_LINE,0,1,ma21);
     fastMa = ma21[0];
     
     //Get the 50 peroid moving average
     ma50Handle = iMA(_Symbol,PERIOD_CURRENT,50,0,MODE_SMMA,PRICE_CLOSE);
     CopyBuffer(ma50Handle,MAIN_LINE,0,1,ma50);
     middleMa = ma50[0];
     
     //Get the 200 peroid moving average
     ma200Handle = iMA(_Symbol,PERIOD_CURRENT,200,0,MODE_SMMA,PRICE_CLOSE);
     CopyBuffer(ma200Handle,MAIN_LINE,0,1,ma200);
     slowMa = ma200[0];
     
     //Get Current Trend
     if (fastMa > slowMa){
         isUptrend = true;
     } else{
         isUptrend = false;
     }
     
     //Get RSI
     rsiHandle = iRSI(_Symbol,PERIOD_CURRENT,14,PRICE_CLOSE);
     CopyBuffer(rsiHandle,MAIN_LINE,0,1,rsiArray);
     rsi = rsiArray[0];
     
     //Get Fractals
     fractalhandle = iFractals(_Symbol,PERIOD_CURRENT);
     CopyBuffer(fractalhandle,UPPER_LINE,3,1,upperFractalArray);
     CopyBuffer(fractalhandle,LOWER_LINE,3,1,lowerFractalArray);
     
     if (upperFractalArray[0] != DBL_MAX){
      upperFractal = upperFractalArray[0];
      signal = "buy";
     }
     if(lowerFractalArray[0] != DBL_MAX){
      lowerFractal = lowerFractalArray[0];
      signal = "sell";
     }
     
     //Get closure of candle
     int currentBars = iBars(_Symbol,PERIOD_CURRENT);
     if (currentBars != barsTotal){
      candleClosed = true;
      barsTotal = currentBars;
     }
     
     positionTotal = PositionsTotal();
     
     
     if (positionTotal == 0){
         if(isUptrend == true){
            if(candleClosed == true && signal == "buy"){
               candleClosed = false;
               double lastCandleOpen = iOpen(NULL,PERIOD_CURRENT,1);
               double lastCandleClose = iClose(NULL,PERIOD_CURRENT,1);
               double lastSecondCandleOpen = iOpen(NULL,PERIOD_CURRENT,2);
               double lastSecondCandleClose = iClose(NULL,PERIOD_CURRENT,2);
               double lastThirdCandleOpen = iOpen(NULL,PERIOD_CURRENT,3);
               double lastThirdCandleClose = iClose(NULL,PERIOD_CURRENT,3);
               double lastFourthCandleOpen = iOpen(NULL,PERIOD_CURRENT,4);
               double lastFourthCandleClose = iClose(NULL,PERIOD_CURRENT,4);
               double currentPipSize = lastCandleClose - lastCandleOpen;
               if(lastCandleClose > lastCandleOpen){
                  isBullish = true;
               } else{
                  isBullish = false;
               }
               if(lastSecondCandleClose > lastSecondCandleOpen){
                  isBullish2 = true;
               } else{
                  isBullish2 = false;
               }
               if(lastThirdCandleClose > lastThirdCandleOpen){
                  isBullish3 = true;
               } else{
                  isBullish3 = false;
               }
               if(lastFourthCandleClose > lastFourthCandleOpen){
                  isBullish4 = true;
               } else{
                  isBullish4 = false;
               }
               if(isBullish == true && isBullish2 == false && isBullish3 == false && isBullish4 == false){
                  double lastPipSize = lastSecondCandleOpen - lastSecondCandleClose;
                  if (currentPipSize > lastPipSize){
                     isEngulfing = true;
                  } else {
                     isEngulfing = false;
                  }
                  if(currentPipSize < threshold && rsi > 50 && isEngulfing == true){
                     trade.Buy(lotSize,_Symbol,0.0,0.0,0.0);
                  }
               }
            }
         } else{
               if(candleClosed == true && signal == "sell"){
               candleClosed = false;
               double lastCandleOpen = iOpen(NULL,PERIOD_CURRENT,1);
               double lastCandleClose = iClose(NULL,PERIOD_CURRENT,1);
               double lastSecondCandleOpen = iOpen(NULL,PERIOD_CURRENT,2);
               double lastSecondCandleClose = iClose(NULL,PERIOD_CURRENT,2);
               double lastThirdCandleOpen = iOpen(NULL,PERIOD_CURRENT,3);
               double lastThirdCandleClose = iClose(NULL,PERIOD_CURRENT,3);
               double lastFourthCandleOpen = iOpen(NULL,PERIOD_CURRENT,4);
               double lastFourthCandleClose = iClose(NULL,PERIOD_CURRENT,4);
               double currentPipSize = lastCandleOpen - lastCandleClose;
               if(lastCandleClose > lastCandleOpen){
                  isBullish = true;
               } else{
                  isBullish = false;
               }
               if(lastSecondCandleClose > lastSecondCandleOpen){
                  isBullish2 = true;
               } else{
                  isBullish2 = false;
               }
               if(lastThirdCandleClose > lastThirdCandleOpen){
                  isBullish3 = true;
               } else{
                  isBullish3 = false;
               }
               if(lastFourthCandleClose > lastFourthCandleOpen){
                  isBullish4 = true;
               } else{
                  isBullish4 = false;
               }
               if(isBullish == false && isBullish2 == true && isBullish3 == true && isBullish4 == true){
                  double lastPipSize = lastSecondCandleClose - lastSecondCandleOpen;
                  if (currentPipSize > lastPipSize){
                     isEngulfing = true;
                  } else {
                     isEngulfing = false;
                  }
                  if(currentPipSize < threshold && rsi < 50 && isEngulfing == true){
                     trade.Sell(lotSize,_Symbol,0.0,0.0,0.0);
                  }
               }
            }
         }
     } else{
             for (int i = 0; i < positionTotal; i++) {
             // Retrieve the ticket number of the position
             ulong ticket = PositionGetTicket(i);
             // Retrieve other position information using the ticket number
             double positionVolume = PositionGetDouble(POSITION_VOLUME);
             double positionPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
             double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
             double positionProfit = PositionGetDouble(POSITION_PROFIT);
             long positionType = PositionGetInteger(POSITION_TYPE);
             double positionStopLoss = PositionGetDouble(POSITION_SL);
             double pips = positionProfit/positionVolume;
             // Output the position information
             Print("Position ", i+1);
             Print("Ticket: ", ticket);
             Print("Volume: ", positionVolume);
             Print("Price: ", positionPrice);
             Print("Open Price: ", openPrice);
             Print("Profit: ", positionProfit);
             Print("Pips: ",  pips);
             Print("============================");
             if (positionType == POSITION_TYPE_BUY && positionStopLoss == 0.0){
                  trade.PositionModify(ticket,openPrice - 75,openPrice + 110);
             }
             if (positionType == POSITION_TYPE_SELL && positionStopLoss == 0.0){
                  trade.PositionModify(ticket,openPrice + 75,openPrice - 110);
             }
         }
     }
   
  }

