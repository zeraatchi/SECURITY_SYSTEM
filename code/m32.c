/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/7/2015
Author  : payman zeraatchi
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega32.h>
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>
#include <stdio.h>

#include "MFRC522.h"



void int0_on();
void int0_off();

void int1_on();
void int1_off();

void int2_on();
void int2_off();

void menu();
void sub_menu();

void siren_on();
void siren_off();

void dor_lock();
void dor_unlock();

void beep();
  bit lock=0;
 unsigned char status,i;  
 unsigned char st=0;
unsigned char g_ucTempbuf[20];

#define ledg PORTD.6
#define ledr PORTD.7

#define in1 PORTB.0
#define in2 PORTB.1

#define en PORTA.7

#define rfid_rst PORTB.3

 unsigned char menu_count=1;    
 unsigned int tag_read_counter=0;    
 eeprom  unsigned char tag_code[4];

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
unsigned char s[4];
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }   
   if (rx_buffer[0]=='*' && rx_buffer[1]=='c'&& rx_buffer[2]=='c' ) {
   lcd_clear();  
   lcd_puts("Clear Successful");   
   delay_ms(1500);    
   menu_count--;
   menu();
   }
   else if (rx_buffer[0]=='*' && rx_buffer[1]=='w')  
   {lcd_clear(); 
   lcd_puts("  Remote set !");
   }
   else   if  (rx_buffer[0]=='#' ) {   

   if (rx_buffer[2]==2&& lock==0){  
    lcd_puts("     LOCK!");    
    
     dor_lock(); 
  delay_ms(10);
  GIFR=0xE0;
  lock=1;
  int0_on();
  int1_on();   
        lcd_clear();  
         lcd_puts("Unlock tag Code:");  
         lcd_gotoxy(0,1); 
         itoa(tag_code[0],s);
         lcd_puts(s);   
         lcd_gotoxy(4,1); 
         itoa(tag_code[1],s);
         lcd_puts(s);
         lcd_gotoxy(8,1); 
         itoa(tag_code[2],s);
         lcd_puts(s);
         lcd_gotoxy(12,1); 
         itoa(tag_code[3],s);
         lcd_puts(s);
         }
  else if (rx_buffer[2]==4 && lock==1) {   
   siren_off();  
   lcd_clear();
  lcd_puts("    UNLOCK !");   
  ledr=0;
  lock=0;
  GIFR=0xE0;
  int0_off();
  int1_off(); 
  dor_unlock(); 
  delay_ms(1000);
  menu_count=1; 
   
  menu();   
  }
 }  
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif



 
 
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
unsigned char s[4];

status = PcdRequest(PICC_REQALL, g_ucTempbuf);
        if (status != MI_OK)
         { 
            PcdReset();
            delay_ms(1);
            PcdAntennaOff(); 
            delay_ms(1);
            PcdAntennaOn();
            delay_ms(1);
             }  
            
                    
	   else{
			
        status = PcdAnticoll(g_ucTempbuf);
        if (status == MI_OK) 
        {
        lcd_clear();  
         lcd_puts(" Detected Code:");  
         lcd_gotoxy(0,1); 
         itoa(g_ucTempbuf[0],s);
         lcd_puts(s);   
         lcd_gotoxy(4,1); 
         itoa(g_ucTempbuf[1],s);
         lcd_puts(s);
         lcd_gotoxy(8,1); 
         itoa(g_ucTempbuf[2],s);
         lcd_puts(s);
         lcd_gotoxy(12,1); 
         itoa(g_ucTempbuf[3],s);
         lcd_puts(s);  
         beep(); 
         TCCR0=0x00;
         delay_ms(2000);
         if (st==1){
         tag_code[0]=g_ucTempbuf[0];   
         delay_ms(10);
         tag_code[1]=g_ucTempbuf[1];  
         delay_ms(10);
         tag_code[2]=g_ucTempbuf[2];  
         delay_ms(10);
         tag_code[3]=g_ucTempbuf[3];   
         delay_ms(10);
         lcd_clear();
         lcd_puts(" Tag code Saved!"); 
         st=0; 
         delay_ms(2000); 
         menu_count--;
         }
         else if (st==2)
         {   
         tag_code[0]=0;   
         delay_ms(10);
         tag_code[1]=0;  
         delay_ms(10);
         tag_code[2]=0;  
         delay_ms(10);
         tag_code[3]=0;   
         delay_ms(10);
         lcd_clear();
         lcd_puts("  Tag Cleared!");  
         st=0;
         delay_ms(2000); 
         menu_count--; 
         } 
         menu_count--;
         menu();
         }  
         }
   if (tag_read_counter<400) tag_read_counter++;
   else { 
        TCCR0=0x00;
        TCNT0=0x00;
        OCR0=0x00;     
        st=0;  
       menu_count--;
       menu();
       }

}

interrupt [EXT_INT2] void ext_int2_isr(void)
{

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;
delay_ms(500);
menu();

}

interrupt [EXT_INT0] void ext_int0_isr(void)
{
int0_off();
int1_off();
siren_on();
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
int0_off();
int1_off();
siren_on();
}


interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
  if (OCR1A<500) OCR1A=OCR1A+1; 
  else OCR1A=0xa0;

}

void main(void)
{
char s[4];

int j;



PORTA=0x00;
DDRA=0x00;
DDRA.7=1;


PORTB=0x00;
DDRB=0x00;
DDRB.0=1;
DDRB.1=1;
DDRB.3=1;
DDRB.4=1;
DDRB.5=1;
DDRB.7=1;
rfid_rst=0;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;
DDRD.5=1;

DDRD.6=1;
DDRD.7=1;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
//TCCR1A=0x40;
//TCCR1B=0x0B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
//OCR1A=0xa0;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
GICR=0x00;
MCUCR=0x0A;
MCUCSR=0x00;
GIFR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x11;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x06;
UBRRL=0x82;


ACSR=0x80;
SFIOR=0x00;


ADCSRA=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 125.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x53;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;



#asm("sei")

rfid_rst=0;
delay_ms(100);
rfid_rst=1;
delay_ms(100);
status=PcdReset();

lcd_init(16);

lcd_clear();
lcd_puts(" RFID based Car");
lcd_gotoxy(0,1);
lcd_puts("Security  System");

int2_on();
while(1){

if (lock==1){
     ledr=~ledr; 
status = PcdRequest(PICC_REQALL, g_ucTempbuf);
        if (status != MI_OK)
         { 
            PcdReset();
            delay_ms(100);
            PcdAntennaOff(); 
            delay_ms(100);
            PcdAntennaOn();
            delay_ms(100);
             }  
           
                    
	   else{
			
        status = PcdAnticoll(g_ucTempbuf);
        if (status == MI_OK) 
        {    
        if (g_ucTempbuf[0]==tag_code[0] && g_ucTempbuf[1]==tag_code[1] && 
        g_ucTempbuf[2]==tag_code[2] && g_ucTempbuf[3]==tag_code[3]  ){ 
        siren_off();
        int0_off();
        int1_off();
        GIFR=0xE0;
        lcd_clear();  
         lcd_puts("    UNLOCK !");  
         lock=0;  
         ledr=0;  
         dor_unlock();
         delay_ms(2000);
         menu();
         } 
         else {
                 lcd_clear();  
                lcd_puts("   Wrong tag!"); 
                }
         }     
         } 
         }
}
}


void int0_on(){

GICR|=0x40;

}

void int0_off(){
GICR&=0xA0;

}

void int1_on(){
GICR|=0x80;
}

void int1_off(){
GICR&=0x60;

}

void int2_on(){
GICR|=0x20;
}

void int2_off(){
GICR&=0xDF;

}

void menu(){
if (PINB.2==1){
lcd_clear();
switch (menu_count)
{
case 1:
  lcd_puts("   Set Remote"); 
  menu_count++; 
  break;
case 2:
   lcd_puts("  Clear Remote");   
   menu_count++;
   break;
case 3:
   lcd_puts("  Set RFID Tag");  
   menu_count++;  
   break; 
case 4:
   lcd_puts(" Clear RFID Tag");  
   menu_count++;
   break;     
case 5:
   lcd_puts(" Read RFID Tag");   
   menu_count++;
   break; 
case 6:
   lcd_puts("      Lock");   
   menu_count++;
   break; 
case 7:
   lcd_puts("     Unlock");   
   menu_count=1;
   break;
    }                        
 }   
else {
delay_ms(500);
sub_menu();
}
}

void sub_menu(){
unsigned char s[4];
lcd_clear();
switch (menu_count)
{
case 2:
  lcd_puts(" Press Lock key");
  lcd_gotoxy(0,1);
  lcd_puts("   On  Remote");   
  UDR='0';
  break;  
case 3:
  lcd_puts("    waite..."); 
  UDR='6';
  break;   
case 4:
  lcd_puts("Waite for Tag..."); 
  tag_read_counter=0;
  st=1;
  TIMSK|=0x01; 
  TCCR0=0x05; 
  break; 

case 5:
  lcd_puts("Waite for Tag..."); 
  tag_read_counter=0;
  st=2;
  TIMSK|=0x01; 
  TCCR0=0x05; 
  break; 
 
   
   case 6:
  lcd_puts("Waite for Tag..."); 
  tag_read_counter=0;
  st=0;
  TIMSK|=0x01; 
  TCCR0=0x05; 
  break;    
  
   case 7:
  lcd_puts("     LOCK!");    

  dor_lock(); 
  delay_ms(10);
  GIFR=0xE0;
  lock=1;
  int0_on();
  int1_on();   
        lcd_clear();  
         lcd_puts("Unlock tag Code:");  
         lcd_gotoxy(0,1); 
         itoa(tag_code[0],s);
         lcd_puts(s);   
         lcd_gotoxy(4,1); 
         itoa(tag_code[1],s);
         lcd_puts(s);
         lcd_gotoxy(8,1); 
         itoa(tag_code[2],s);
         lcd_puts(s);
         lcd_gotoxy(12,1); 
         itoa(tag_code[3],s);
         lcd_puts(s);  
         
  break; 
  
  case 1:
  siren_off(); 
  lcd_puts("    UNLOCK !");   
  ledr=0;
  lock=0;
  GIFR=0xE0;
  int0_off();
  int1_off();
  dor_unlock(); 
  menu();
  break;
   }                         
  
}

void siren_on(){
TCCR1A=0x40;
TCCR1B=0x0B;
OCR1A=0xa0;

TIMSK|=0x11;
}

void siren_off(){
TCCR1A=0x00;
TCCR1B=0x00;
OCR1A=0x00;

TIMSK&=0xEE;
}

void beep(){
ledg=1;
TCNT1=0x00;
TCCR1A=0x40;
TCCR1B=0x0B;
OCR1A=0x50;

TIMSK&=0xEE;
delay_ms(300);
ledg=0;
TCCR1A=0x00;
TCCR1B=0x00;
OCR1A=0x00;
ledg=1;
delay_ms(100);
TCCR1A=0x40;
TCCR1B=0x0B;
OCR1A=0x50;
delay_ms(300);
ledg=0;
TCCR1A=0x00;
TCCR1B=0x00;
OCR1A=0x00;

}

void dor_lock(){
     en=0;
     in1=1;
     delay_ms(1);
     in2=0;  
     en=1;
     
      delay_ms(30); 
      en=0; 
      } 
      
void dor_unlock(){
     en=0;
     in1=0;
     delay_ms(1);
     in2=1;  
     en=1;
     
      delay_ms(70); 
      en=0; 
      }

