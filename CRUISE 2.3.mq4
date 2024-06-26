//+------------------------------------------------------------------+
//|                                                 Sheikhan 2.0.mq4 |
//|                                                     OMID RAHMANI |
//|                                                 @themamadrahmani |
//+------------------------------------------------------------------+
#property copyright "OMID RAHMANI"
#property link      "@themamadrahmani"
#property version   "1.00"
#property strict

input double risk_percent_per_trade=0.2;
input double base_balance=1000;
      double stop_usd=risk_percent_per_trade*base_balance/100;
input string box_start_time="6:00";
input string box_end_time="9:15";
input string session_end_time="23:00";
input double tp1_factor=1.000;
input double tp2_factor=1.809;
input double tp3_factor=2.618;
input double tp4_factor=3.427;
input double tp5_factor=4.236;
input int box_min_size=150;
input int box_max_size=800;
input int buy_entry_line_shift=20;
input int sell_entry_line_shift=20;
input color box_ok_color=clrLightBlue;
input color box_min_color=clrRed;
input color box_max_color=clrOrange;
input color box_session_color=clrLinen;
input color box_profit_color=clrLightGreen;
int level[366];
int box_size[366];
double box_high[366];
double box_low[366];
double lot_size[366];
datetime start_time[366];
datetime end_time[366];
bool have_buy[11][366];
bool have_sell[11][366];
bool have_buystop[11][366];
bool have_sellstop[11][366];
bool had_buy[11][366];
bool had_sell[11][366];
bool had_buystop[11][366];
bool had_sellstop[11][366];
int today=DayOfYear();
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  today=DayOfYear();
  Alert("CRUISE EXPERT IS LOADED.");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  for(int i=0;i<366;i++)
     {
     for(int j=0;j<11;j++)
        {
        have_buy[j][i]=false;
        have_sell[j][i]=false;
        have_buystop[j][i]=false;
        have_sellstop[j][i]=false;
        }
     }
  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
     if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUY) have_buy[StringToInteger(OrderComment())][OrderMagicNumber()]=true;
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUY) had_buy[StringToInteger(OrderComment())][OrderMagicNumber()]=true;
     
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELL) have_sell[StringToInteger(OrderComment())][OrderMagicNumber()]=true;
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELL) had_sell[StringToInteger(OrderComment())][OrderMagicNumber()]=true;

     if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP) have_buystop[StringToInteger(OrderComment())][OrderMagicNumber()]=true;
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP) had_buystop[StringToInteger(OrderComment())][OrderMagicNumber()]=true;

     if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP) have_sellstop[StringToInteger(OrderComment())][OrderMagicNumber()]=true;
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP) had_sellstop[StringToInteger(OrderComment())][OrderMagicNumber()]=true;
     }
  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
     if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=box_high[OrderMagicNumber()]+tp1_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()<OrderOpenPrice())
        {
        int ticket_brf1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,clrNONE);
        if (ticket_brf1>0) Alert("ORDER "+OrderComment()+" RISK FREE DONE.");
        }
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=box_high[OrderMagicNumber()]+tp2_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()<box_high[OrderMagicNumber()]+tp1_factor*box_size[OrderMagicNumber()]*Point)
        {
        int ticket_brf2=OrderModify(OrderTicket(),OrderOpenPrice(),box_high[OrderMagicNumber()]+tp1_factor*box_size[OrderMagicNumber()]*Point,OrderTakeProfit(),0,clrNONE);
        if (ticket_brf2>0) Alert("ORDER "+OrderComment()+" STOP MOVED TO TP1.");
        }    
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=box_high[OrderMagicNumber()]+tp3_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()<box_high[OrderMagicNumber()]+tp2_factor*box_size[OrderMagicNumber()]*Point)
        {
        int ticket_brf3=OrderModify(OrderTicket(),OrderOpenPrice(),box_high[OrderMagicNumber()]+tp2_factor*box_size[OrderMagicNumber()]*Point,OrderTakeProfit(),0,clrNONE);
        if (ticket_brf3>0) Alert("ORDER "+OrderComment()+" STOP MOVED TO TP2.");       
        } 
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=box_high[OrderMagicNumber()]+tp4_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()<box_high[OrderMagicNumber()]+tp3_factor*box_size[OrderMagicNumber()]*Point)
        {
        int ticket_brf4=OrderModify(OrderTicket(),OrderOpenPrice(),box_high[OrderMagicNumber()]+tp3_factor*box_size[OrderMagicNumber()]*Point,OrderTakeProfit(),0,clrNONE);
        if (ticket_brf4>0) Alert("ORDER "+OrderComment()+" STOP MOVED TO TP3.");       
        }                          
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=box_low[OrderMagicNumber()]-tp1_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()>OrderOpenPrice())
        {
        int ticket_srf1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,clrNONE);
        if (ticket_srf1>0) Alert("ORDER "+OrderComment()+" RISK FREE DONE.");      
        } 
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=box_low[OrderMagicNumber()]-tp2_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()>box_low[OrderMagicNumber()]-tp1_factor*box_size[OrderMagicNumber()]*Point)
        {
        int ticket_srf2=OrderModify(OrderTicket(),OrderOpenPrice(),box_low[OrderMagicNumber()]-tp1_factor*box_size[OrderMagicNumber()]*Point,OrderTakeProfit(),0,clrNONE);
        if (ticket_srf2>0) Alert("ORDER "+OrderComment()+" STOP MOVED TO TP1.");       
        }   
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=box_low[OrderMagicNumber()]-tp3_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()>box_low[OrderMagicNumber()]-tp2_factor*box_size[OrderMagicNumber()]*Point)
        {
        int ticket_srf3=OrderModify(OrderTicket(),OrderOpenPrice(),box_low[OrderMagicNumber()]-tp2_factor*box_size[OrderMagicNumber()]*Point,OrderTakeProfit(),0,clrNONE);
        if (ticket_srf3>0) Alert("ORDER "+OrderComment()+" STOP MOVED TO TP2.");       
        } 
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=box_low[OrderMagicNumber()]-tp4_factor*box_size[OrderMagicNumber()]*Point && OrderStopLoss()>box_low[OrderMagicNumber()]-tp3_factor*box_size[OrderMagicNumber()]*Point)
        {
        int ticket_srf4=OrderModify(OrderTicket(),OrderOpenPrice(),box_low[OrderMagicNumber()]-tp3_factor*box_size[OrderMagicNumber()]*Point,OrderTakeProfit(),0,clrNONE);
        if (ticket_srf4>0) Alert("ORDER "+OrderComment()+" STOP MOVED TO TP3.");       
        }                               
     } 
  //اگر تی پی اول بخورد اردرهای مارتینگل شده را پارک میکند
  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
     if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
     if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP && Ask<=box_low[OrderMagicNumber()]-tp1_factor*box_size[OrderMagicNumber()]*Point && StringToInteger(OrderComment())>5)
        {
        int ticket_obd1=OrderDelete(OrderTicket(),clrRed);
        if (ticket_obd1>0) Alert("TP1 HIT. ORDER BUY STOP "+OrderComment()+" DELETED.");        
        }
     if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP && Bid>=box_high[OrderMagicNumber()]+tp1_factor*box_size[OrderMagicNumber()]*Point && StringToInteger(OrderComment())>5)
        {
        int ticket_osd1=OrderDelete(OrderTicket(),clrRed);
        if (ticket_osd1>0) Alert("TP1 HIT. ORDER SELL STOP "+OrderComment()+" DELETED.");        
        }                 
     }         
  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
     if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
     //پاک کردن اردرهای روز گذشته
     if(OrderSymbol()==Symbol() && (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) && (OrderMagicNumber()<DayOfYear() || (DayOfYear()==1 && OrderMagicNumber()>DayOfYear()) ) )
        {
        int ticket_obd2=OrderDelete(OrderTicket(),clrOrange);
        if (ticket_obd2>0) Alert("SESSION END. ORDER BUY STOP "+OrderComment()+" DELETED.");         
        }
     //پاک کردن اردرهایی که ساعت آنها گذشته
     if(OrderSymbol()==Symbol() && (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) && (TimeHour(session_end_time)>TimeHour(TimeCurrent()) || (TimeHour(session_end_time)==TimeHour(TimeCurrent()) && TimeMinute(session_end_time)>TimeMinute(TimeCurrent()))) )
        {
        int ticket_osd2=OrderDelete(OrderTicket(),clrOrange);  
        if (ticket_osd2>0) Alert("SESSION END. ORDER SELL STOP "+OrderComment()+" DELETED.");                  
        }
     }  
  if(start_time[DayOfYear()]==0) start_time[DayOfYear()]=StringToTime(IntegerToString(Year())+"."+IntegerToString(Month())+"."+IntegerToString(Day())+" "+box_start_time);    
  if(end_time[DayOfYear()]==0)   end_time[DayOfYear()]=StringToTime(IntegerToString(Year())+"."+IntegerToString(Month())+"."+IntegerToString(Day())+" "+box_end_time);
  
  if(box_size[DayOfYear()]==0 && TimeCurrent()>end_time[DayOfYear()] && end_time[DayOfYear()]>0 )
     {
     //Print("CALCULATING BOX SIZE FOR TODAY "+IntegerToString(DayOfYear()));
     int start_candle=0;
     int end_candle=0;
     for(int i=1;i<97;i++)
        {
        if(Time[i]<=start_time[DayOfYear()] && Time[i-1]>start_time[DayOfYear()])
           {
           start_candle=i;
           break;
           }
        }
     for(int i=1;i<97;i++)
        {
        if(Time[i]<=end_time[DayOfYear()] && Time[i-1]>end_time[DayOfYear()])
           {
           end_candle=i;
           break;
           }
        }        
      Print("START CANDLE ",start_candle);
      Print("END CANDLE ",end_candle);
      if (box_high[DayOfYear()]==0) 
         {
         for (int i=end_candle;i<=start_candle;i++)
            {
            box_high[DayOfYear()]=MathMax(iHigh(Symbol(),PERIOD_M15,i),box_high[DayOfYear()]);
            }
         }
      //Print("BOX HIGH : ",box_high[DayOfYear()]);
      if (box_low[DayOfYear()]==0)
         {
         box_low[DayOfYear()]=box_high[DayOfYear()];         
         for (int i=end_candle;i<=start_candle;i++)
            {
            box_low[DayOfYear()]=MathMin(iLow(Symbol(),PERIOD_M15,i),box_low[DayOfYear()]);
            }
         }  
      //Print("BOX LOW : ",box_low[DayOfYear()]);                
      if (box_size[DayOfYear()]==0) 
         {
         box_size[DayOfYear()]=MathAbs(box_high[DayOfYear()]-box_low[DayOfYear()])/Point;
         }    
      //Print("BOX SIZE FOR TODAY "+IntegerToString(DayOfYear())+" IS : "+IntegerToString(box_size[DayOfYear()])); 
      if (ObjectFind("box_1"+IntegerToString(DayOfYear())) && box_size[DayOfYear()]>0) 
         {
         datetime t1=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_start_time);
         datetime t2=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_end_time);
         datetime t3=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + session_end_time);         
         //Print("DRAWING BOX FOR TODAY "+IntegerToString(DayOfYear()));
         Alert("BOX DRAW DONE.");
         Alert("BOX SIZE : ",NormalizeDouble(box_size[DayOfYear()],0));
         //ObjectCreate("box"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, Time[start_candle],box_low[DayOfYear()],Time[end_candle],box_high[DayOfYear()]);
         ObjectCreate("box_1"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, t1,box_low[DayOfYear()],t2,box_high[DayOfYear()]);         
         if (box_size[DayOfYear()]<=box_max_size && box_size[DayOfYear()]>=box_min_size) 
            {
            ObjectSet("box_1"+IntegerToString(DayOfYear()),OBJPROP_COLOR, box_ok_color);
            Alert("BOX SIZE IS OK.");
            }
         if (box_size[DayOfYear()]<box_min_size) 
            {
            ObjectSet("box_1"+IntegerToString(DayOfYear()),OBJPROP_COLOR, box_min_color);
            Alert("BOX SIZE IS < MIN.");
            }
         if (box_size[DayOfYear()]>box_max_size) 
            {
            ObjectSet("box_1"+IntegerToString(DayOfYear()),OBJPROP_COLOR, box_max_color);
            Alert("BOX SIZE IS > MAX.");
            }
         ObjectSet("box_1"+IntegerToString(DayOfYear()), OBJPROP_BACK, true);
         ObjectSet("box_1"+IntegerToString(DayOfYear()), OBJPROP_WIDTH, 5);
         ObjectSet("box_1"+IntegerToString(DayOfYear()), OBJPROP_STYLE, STYLE_SOLID);
         }
         
      if (ObjectFind("lable_1"+IntegerToString(DayOfYear())>0)) 
         {
         datetime t1=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_start_time);  
         datetime t2=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_end_time);                  
         ObjectCreate("lable_1"+IntegerToString(DayOfYear()), OBJ_TEXT, 0, (t1+t2)/2, box_low[DayOfYear()]);
         ObjectSet("lable_1"+IntegerToString(DayOfYear()), OBJPROP_FONTSIZE, 10);
         ObjectSetText("lable_1"+IntegerToString(DayOfYear()), IntegerToString(box_size[DayOfYear()])+" Points" , 10, "Arial Black", clrBlack);           
         }
           
      if (ObjectFind("box_2"+IntegerToString(DayOfYear())) && box_size[DayOfYear()]>0) 
         {
         datetime t1=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_start_time);
         datetime t2=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_end_time);
         datetime t3=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + session_end_time);         
         //Print("DRAWING BOX FOR TODAY "+IntegerToString(DayOfYear()));
         //Alert("BOX DRAW DONE.");
         //Alert("BOX SIZE : ",NormalizeDouble(box_size[DayOfYear()],0));
         //ObjectCreate("box"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, Time[start_candle],box_low[DayOfYear()],Time[end_candle],box_high[DayOfYear()]);
         ObjectCreate("box_2"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, t2,box_low[DayOfYear()]-tp1_factor*box_size[DayOfYear()]*Point,t3,box_high[DayOfYear()]+tp1_factor*box_size[DayOfYear()]*Point);         
         ObjectSet("box_2"+IntegerToString(DayOfYear()),OBJPROP_COLOR, box_session_color);
         ObjectSet("box_2"+IntegerToString(DayOfYear()), OBJPROP_BACK, true);
         ObjectSet("box_2"+IntegerToString(DayOfYear()), OBJPROP_WIDTH, 5);
         ObjectSet("box_2"+IntegerToString(DayOfYear()), OBJPROP_STYLE, STYLE_SOLID);
         }  
      if (ObjectFind("box_3"+IntegerToString(DayOfYear())) && box_size[DayOfYear()]>0) 
         {
         datetime t1=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_start_time);
         datetime t2=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_end_time);
         datetime t3=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + session_end_time);         
         //Print("DRAWING BOX FOR TODAY "+IntegerToString(DayOfYear()));
         //Alert("BOX DRAW DONE.");
         //Alert("BOX SIZE : ",NormalizeDouble(box_size[DayOfYear()],0));
         //ObjectCreate("box"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, Time[start_candle],box_low[DayOfYear()],Time[end_candle],box_high[DayOfYear()]);
         ObjectCreate("box_3"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, t2,box_low[DayOfYear()]-tp5_factor*box_size[DayOfYear()]*Point,t3,box_low[DayOfYear()]-tp1_factor*box_size[DayOfYear()]*Point);         
         ObjectSet("box_3"+IntegerToString(DayOfYear()),OBJPROP_COLOR, box_profit_color);
         ObjectSet("box_3"+IntegerToString(DayOfYear()), OBJPROP_BACK, true);
         ObjectSet("box_3"+IntegerToString(DayOfYear()), OBJPROP_WIDTH, 5);
         ObjectSet("box_3"+IntegerToString(DayOfYear()), OBJPROP_STYLE, STYLE_SOLID);
         }  
      if (ObjectFind("box_4"+IntegerToString(DayOfYear())) && box_size[DayOfYear()]>0) 
         {
         datetime t1=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_start_time);
         datetime t2=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_end_time);
         datetime t3=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + session_end_time);         
         //Print("DRAWING BOX FOR TODAY "+IntegerToString(DayOfYear()));
         //Alert("BOX DRAW DONE.");
         //Alert("BOX SIZE : ",NormalizeDouble(box_size[DayOfYear()],0));
         //ObjectCreate("box"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, Time[start_candle],box_low[DayOfYear()],Time[end_candle],box_high[DayOfYear()]);
         ObjectCreate("box_4"+IntegerToString(DayOfYear()), OBJ_RECTANGLE, 0, t2,box_high[DayOfYear()]+tp1_factor*box_size[DayOfYear()]*Point,t3,box_high[DayOfYear()]+tp5_factor*box_size[DayOfYear()]*Point);         
         ObjectSet("box_4"+IntegerToString(DayOfYear()),OBJPROP_COLOR, box_profit_color);
         ObjectSet("box_4"+IntegerToString(DayOfYear()), OBJPROP_BACK, true);
         ObjectSet("box_4"+IntegerToString(DayOfYear()), OBJPROP_WIDTH, 5);
         ObjectSet("box_4"+IntegerToString(DayOfYear()), OBJPROP_STYLE, STYLE_SOLID);
         } 
      if (ObjectFind("fibo_1"+IntegerToString(DayOfYear())) && box_size[DayOfYear()]>0) 
         {   
         datetime t1=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_start_time);
         datetime t2=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + box_end_time);
         datetime t3=StrToTime(IntegerToString(Year())+ "." +IntegerToString(Month())+ "." +IntegerToString(Day()) + " " + session_end_time); 
                        
         string objname = "fibo_1"+IntegerToString(DayOfYear());
         ObjectCreate(objname,OBJ_FIBO,0,t1,box_low[DayOfYear()],t2,box_high[DayOfYear()]);
         ObjectSet(objname,OBJPROP_RAY,false);
         ObjectSet(objname,OBJPROP_LEVELCOLOR,clrBlack); 
         ObjectSet(objname,OBJPROP_FIBOLEVELS,12);
         ObjectSet(objname,OBJPROP_LEVELSTYLE,STYLE_SOLID); 
          
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+0,0);
         ObjectSetFiboDescription(objname,0,"BUY ENTRY.");

         ObjectSet(objname,OBJPROP_FIRSTLEVEL+1,-tp1_factor);
         ObjectSetFiboDescription(objname,1,"BUY TP1 & RISK FREE.");

         ObjectSet(objname,OBJPROP_FIRSTLEVEL+2,-tp2_factor);
         ObjectSetFiboDescription(objname,2,"BUY TP2.");
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+3,-tp3_factor);
         ObjectSetFiboDescription(objname,3,"BUY TP3.");
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+4,-tp4_factor);
         ObjectSetFiboDescription(objname,4,"BUY TP4.");                                                                  
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+5,-tp5_factor);
         ObjectSetFiboDescription(objname,5,"BUY TP5."); 
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+6,tp1_factor);
         ObjectSetFiboDescription(objname,6,"SELL ENTRY.");

         ObjectSet(objname,OBJPROP_FIRSTLEVEL+7,tp1_factor+1);
         ObjectSetFiboDescription(objname,7,"SELL TP1 & RISK FREE.");

         ObjectSet(objname,OBJPROP_FIRSTLEVEL+8,tp2_factor+1);
         ObjectSetFiboDescription(objname,8,"SELL TP2.");
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+9,tp3_factor+1);
         ObjectSetFiboDescription(objname,9,"SELL TP3.");
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+10,tp4_factor+1);
         ObjectSetFiboDescription(objname,10,"SELL TP4.");                                                                  
         
         ObjectSet(objname,OBJPROP_FIRSTLEVEL+11,tp5_factor+1);
         ObjectSetFiboDescription(objname,11,"SELL TP5.");                    
         }
      }

   if(lot_size[DayOfYear()]==0 && box_size[DayOfYear()]>=box_min_size && box_size[DayOfYear()]<=box_max_size)
      {
      double PIP_VALUE=NormalizeDouble((MarketInfo(Symbol(),MODE_TICKVALUE)*Point)/MarketInfo(Symbol(),MODE_TICKSIZE),2);
      if (Digits==5) lot_size[DayOfYear()]= NormalizeDouble(stop_usd/(100000*PIP_VALUE*(box_size[DayOfYear()]*Point)),2);
      if (Digits==4) lot_size[DayOfYear()]= NormalizeDouble(stop_usd/(10000*PIP_VALUE*(box_size[DayOfYear()]*Point)),2);
      if (Digits==3) lot_size[DayOfYear()]= NormalizeDouble(stop_usd/(1000*PIP_VALUE*(box_size[DayOfYear()]*Point)),2);
      if (Digits==2) lot_size[DayOfYear()]= NormalizeDouble(stop_usd/(100*PIP_VALUE*(box_size[DayOfYear()]*Point)),2);
      if (Digits==1) lot_size[DayOfYear()]= NormalizeDouble(stop_usd/(10*PIP_VALUE*(box_size[DayOfYear()]*Point)),2);
      if (Digits==0) lot_size[DayOfYear()]= NormalizeDouble(stop_usd/(1*PIP_VALUE*(box_size[DayOfYear()]*Point)),2);
      if (lot_size[DayOfYear()]>0 && lot_size[DayOfYear()]<MarketInfo(Symbol(),MODE_MINLOT)) lot_size[DayOfYear()]=MarketInfo(Symbol(),MODE_MINLOT);
      //Print("CALCULATED LOT SIZE FOR TODAY "+DayOfYear()+" IS : ",lot_size[DayOfYear()]);
      Alert("CALCULATED LOT SIZE FOR TODAY "+DayOfYear()+" IS : ",lot_size[DayOfYear()]);      
      }
   if(1>0 &&
      lot_size[DayOfYear()]>0 &&
      box_size[DayOfYear()]>=box_min_size &&
      box_size[DayOfYear()]<=box_max_size
      )
      {
      if(!have_buystop[1][DayOfYear()] && !had_buystop[1][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point))
         {
         int ticket_b1=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp1_factor*box_size[DayOfYear()]*Point,
                                 "1",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b1>0) Alert("ORDER BUY STOP 1 SENT.");                                 
         }
      if(!have_buystop[2][DayOfYear()] && !had_buystop[2][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point))
         {
         int ticket_b2=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp2_factor*box_size[DayOfYear()]*Point,
                                 "2",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b2>0) Alert("ORDER BUY STOP 2 SENT.");                                 
         }  
      if(!have_buystop[3][DayOfYear()] && !had_buystop[3][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point))
         {
         int ticket_b3=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp3_factor*box_size[DayOfYear()]*Point,
                                 "3",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b3>0) Alert("ORDER BUY STOP 3 SENT.");                                 
         }  
      if(!have_buystop[4][DayOfYear()] && !had_buystop[4][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point))
         {
         int ticket_b4=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp4_factor*box_size[DayOfYear()]*Point,
                                 "4",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b4>0) Alert("ORDER BUY STOP 4 SENT.");                                 
         } 
      if(!have_buystop[5][DayOfYear()] && !had_buystop[5][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point))
         {
         int ticket_b5=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp5_factor*box_size[DayOfYear()]*Point,
                                 "5",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b5>0) Alert("ORDER BUY STOP 5 SENT.");                                 
         }
      if(!have_sellstop[1][DayOfYear()] && !had_sellstop[1][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point))
         {
         int ticket_s1=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp1_factor*box_size[DayOfYear()]*Point,
                                 "1",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s1>0) Alert("ORDER SELL STOP 1 SENT.");                                 
         }   
      if(!have_sellstop[2][DayOfYear()] && !had_sellstop[2][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point))
         {
         int ticket_s2=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp2_factor*box_size[DayOfYear()]*Point,
                                 "2",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s2>0) Alert("ORDER SELL STOP 2 SENT.");                                  
         }
      if(!have_sellstop[3][DayOfYear()] && !had_sellstop[3][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point))
         {
         int ticket_s3=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp3_factor*box_size[DayOfYear()]*Point,
                                 "3",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s3>0) Alert("ORDER SELL STOP 3 SENT.");                                  
         }  
      if(!have_sellstop[4][DayOfYear()] && !had_sellstop[4][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point))
         {
         int ticket_s4=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp4_factor*box_size[DayOfYear()]*Point,
                                 "4",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s4>0) Alert("ORDER SELL STOP 4 SENT.");                                  
         }   
      if(!have_sellstop[5][DayOfYear()] && !had_sellstop[5][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point))
         {
         int ticket_s5=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp5_factor*box_size[DayOfYear()]*Point,
                                 "5",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s5>5) Alert("ORDER SELL STOP 5 SENT.");                                  
         }   
      if(!had_buy[1][DayOfYear()] && !have_buystop[6][DayOfYear()] && !had_buystop[6][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point) && (have_sell[1][DayOfYear()] || had_sell[1][DayOfYear()]) )
         {
         int ticket_b6=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp1_factor*box_size[DayOfYear()]*Point,
                                 "6",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b6>0) Alert("ORDER BUY STOP MARTINGALE 1 SENT.");                                  
         }  
      if(!had_buy[2][DayOfYear()] && !have_buystop[7][DayOfYear()] && !had_buystop[7][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point) && (have_sell[2][DayOfYear()] || had_sell[2][DayOfYear()]) )
         {
         int ticket_b7=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp2_factor*box_size[DayOfYear()]*Point,
                                 "7",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b7>0) Alert("ORDER BUY STOP MARTINGALE 2 SENT.");                                  
         }  
      if(!had_buy[3][DayOfYear()] && !have_buystop[8][DayOfYear()] && !had_buystop[8][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point) && (have_sell[3][DayOfYear()] || had_sell[3][DayOfYear()]) )
         {
         int ticket_b8=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp3_factor*box_size[DayOfYear()]*Point,
                                 "8",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b8>0) Alert("ORDER BUY STOP MARTINGALE 3 SENT.");                                  
         } 
      if(!had_buy[4][DayOfYear()] && !have_buystop[9][DayOfYear()] && !had_buystop[9][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point) && (have_sell[4][DayOfYear()] || had_sell[4][DayOfYear()]) )
         {
         int ticket_b9=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp4_factor*box_size[DayOfYear()]*Point,
                                 "9",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b9>0) Alert("ORDER BUY STOP MARTINGALE 4 SENT.");                                  
         }  
      if(!had_buy[5][DayOfYear()] && !have_buystop[10][DayOfYear()] && !had_buystop[10][DayOfYear()] && Ask<(box_high[DayOfYear()]+buy_entry_line_shift*Point) && (have_sell[5][DayOfYear()] || had_sell[5][DayOfYear()]) )
         {
         int ticket_b10=OrderSend(Symbol(),
                                 OP_BUYSTOP,
                                 lot_size[DayOfYear()],
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 0,
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 box_high[DayOfYear()]+tp5_factor*box_size[DayOfYear()]*Point,
                                 "10",
                                 DayOfYear(),
                                 0,
                                 clrBlue);
         if (ticket_b10>0) Alert("ORDER BUY STOP MARTINGALE 5 SENT.");                                  
         } 
      if(!had_sell[1][DayOfYear()] && !have_sellstop[6][DayOfYear()] && !had_sellstop[6][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point) && (have_buy[1][DayOfYear()] || had_buy[1][DayOfYear()]) )
         {
         int ticket_s6=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp1_factor*box_size[DayOfYear()]*Point,
                                 "6",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s6>0) Alert("ORDER SELL STOP MARTINGALE 1 SENT.");                                  
         }    
      if(!had_sell[2][DayOfYear()] && !have_sellstop[7][DayOfYear()] && !had_sellstop[7][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point) && (have_buy[2][DayOfYear()] || had_buy[2][DayOfYear()]) )
         {
         int ticket_s7=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp2_factor*box_size[DayOfYear()]*Point,
                                 "7",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s7>0) Alert("ORDER SELL STOP MARTINGALE 2 SENT.");                                  
         }    
      if(!had_sell[3][DayOfYear()] && !have_sellstop[8][DayOfYear()] && !had_sellstop[8][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point) && (have_buy[3][DayOfYear()] || had_buy[3][DayOfYear()]) )
         {
         int ticket_s8=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp3_factor*box_size[DayOfYear()]*Point,
                                 "8",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s8>0) Alert("ORDER SELL STOP MARTINGALE 3 SENT.");                                 
         }  
      if(!had_sell[4][DayOfYear()] && !have_sellstop[9][DayOfYear()] && !had_sellstop[9][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point) && (have_buy[4][DayOfYear()] || had_buy[4][DayOfYear()]) )
         {
         int ticket_s9=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp4_factor*box_size[DayOfYear()]*Point,
                                 "9",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s9>0) Alert("ORDER SELL STOP MARTINGALE 4 SENT.");                                 
         }  
      if(!had_sell[5][DayOfYear()] && !have_sellstop[10][DayOfYear()] && !had_sellstop[10][DayOfYear()] && Bid>(box_low[DayOfYear()]-sell_entry_line_shift*Point) && (have_buy[5][DayOfYear()] || had_buy[5][DayOfYear()]) )
         {
         int ticket_s10=OrderSend(Symbol(),
                                 OP_SELLSTOP,
                                 lot_size[DayOfYear()],
                                 box_low[DayOfYear()]-sell_entry_line_shift*Point,
                                 0,
                                 box_high[DayOfYear()]+buy_entry_line_shift*Point,
                                 box_low[DayOfYear()]-tp5_factor*box_size[DayOfYear()]*Point,
                                 "10",
                                 DayOfYear(),
                                 0,
                                 clrRed);
         if (ticket_s10>0) Alert("ORDER SELL STOP MARTINGALE 5 SENT.");                                 
         }                                                                                                                                                        
      }
  Comment(TimeCurrent());           
  }
//+------------------------------------------------------------------+
