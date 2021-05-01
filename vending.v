`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2019 16:54:18
// Design Name: 
// Module Name: traffic_light
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//Obsługa maszyny stanów
//(input)0 case: pierwsze 3 bity dotyczą opcji reszta bitów definiuje rodzaj monety. 1=1, 2=2, 3=5, 4=10, 5=20, 6=50. np 00110|000 to 50 groszy
//(output)1-3 case: pierwsze 2 bity tp numer case produktu czyli od 1-3, reszta definiuje wydawaną resztę. 3bit to 1 grosz 4bit to 2 grosze 5bit to 5 groszy,
// 6 bit to 10 groszy itd.
//(input)4 case: pierwsze 3 bity dotyczą opcji reszta bitów to wybór produktu np 00001|010 czyli produkt S.
// Aby przypisać cenę produktowi należy najpierw użyć case 0 który przechowuje cenę a następnie przejść do tej opcji
//(input)5 case: pierwsze 3 bity dotyczą opcji, kolejne 2 bity wybór produktu a następne 3 bity jego ilość
//(output)6 case: działa jak case 1-3 tylko że zwraca resztę w przypadku braku produktu na stanie. Należy go zwracać asemblerem aż to oczyszczenia rejestru 
//////////////////////////////////////////////////////////////////////////////////



module vending(
    input clk,
    input rst,
    input [7:0] in_data,
    output [7:0] out_data,
    output reg [10:0] money_storage
    );
    wire [7:0] in_data;
    reg [7:0] out_data_reg;
    reg [7:0] out_data;
    reg[10:0] C;
    reg[10:0] S;
    reg[10:0] P;
    reg[2:0] C_q;
    reg[2:0] S_q;
    reg[2:0] P_q;
    
               
            always @ (posedge clk or posedge rst)begin
                 if (rst == 1) begin
                money_storage <= 11'b00000000000;
                out_data_reg <= 8'b00000000;
                out_data <= 8'b00000000;
                C <= 11'b00011111010; //domyślna cena produktów
                S <= 11'b00001110011;
                P <= 11'b00011010010;
                C_q=2; //domyślna ilość produktów
                S_q=2;
                P_q=2;
                end else
                         begin
                         out_data_reg <= 8'b00000000;
                          case(in_data[2:0])
                             0: if(in_data[7:3] > 0) begin //Ten case gromadzi wrzucone pieniądze 
                                     if(in_data[7:3] == 1) begin money_storage = money_storage + 1;end
                                     if(in_data[7:3] == 2) begin money_storage = money_storage + 2;end
                                     if(in_data[7:3] == 3) begin money_storage = money_storage + 5;end
                                     if(in_data[7:3] == 4) begin money_storage = money_storage + 10;end
                                     if(in_data[7:3] == 5) begin money_storage = money_storage + 20;end
                                     if(in_data[7:3] == 6) begin money_storage = money_storage + 50;end
                                 end 
                               
                             1: if((money_storage >= C)&&(C_q >= 1)) begin //Ten case wybiera produkt, sprawdza czy jest go przynajmniej jedna sztuka i wydaje pieniądze
                                     money_storage = money_storage - C;
                                      while ( money_storage > 0) 
                                    begin
                                   if(money_storage >=50)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                   out_data_reg = out_data_reg ^ 8'b00000100;
                                   money_storage = money_storage -50;
                                   end else if(money_storage >=20)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                   out_data_reg = out_data_reg ^ 8'b00001000;
                                   money_storage = money_storage -20;
                                   end else if(money_storage >=10)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                   out_data_reg = out_data_reg ^ 8'b00010000;
                                   money_storage = money_storage -10;
                                   end else if(money_storage >=5)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                   out_data_reg= out_data_reg ^ 8'b00100000;
                                   money_storage = money_storage -5;
                                   end else if(money_storage >=2)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                   out_data_reg = out_data_reg ^ 8'b01000000;
                                   money_storage = money_storage -2;
                                   end else if(money_storage >=1)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                   out_data_reg = out_data_reg ^ 8'b10000000;
                                   money_storage = money_storage -1;
                                      end
                                       out_data <= out_data_reg; 
                                       C_q <= C_q -1;                                                                         
                                      end 
    
                                 end  
                                 
                             2: if((money_storage >= S)&&(S_q >= 1)) begin //Ten case wybiera produkt, sprawdza czy jest go przynajmniej jedna sztuka i wydaje pieniądze
                                     money_storage = money_storage - S;
                                      while ( money_storage > 0) 
                                     begin
                                    if(money_storage >=50)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                    out_data_reg = out_data_reg ^ 8'b00000100;
                                    money_storage = money_storage -50;
                                    end else if(money_storage >=20)begin
                                    out_data_reg[1:0] <= in_data[1:0];
                                    out_data_reg = out_data_reg ^ 8'b00001000;
                                    money_storage = money_storage -20;
                                    end else if(money_storage >=10)begin
                                    out_data_reg[1:0] <= in_data[1:0];
                                    out_data_reg = out_data_reg ^ 8'b00010000;
                                    money_storage = money_storage -10;
                                    end else if(money_storage >=5)begin
                                    out_data_reg[1:0] <= in_data[1:0];
                                    out_data_reg= out_data_reg ^ 8'b00100000;
                                    money_storage = money_storage -5;
                                    end else if(money_storage >=2)begin
                                    out_data_reg[1:0] <= in_data[1:0];
                                    out_data_reg = out_data_reg ^ 8'b01000000;
                                    money_storage = money_storage -2;
                                    end else if(money_storage >=1)begin
                                    out_data_reg[1:0] <= in_data[1:0];
                                    out_data_reg = out_data_reg ^ 8'b10000000;
                                    money_storage = money_storage -1;
                                     end
                                      out_data <= out_data_reg;
                                      S_q <= S_q -1;                                                                            
                                     end
                                 end
                                     
                              3: if((money_storage >= P)&&(P_q >= 1)) begin //Ten case wybiera produkt, sprawdza czy jest go przynajmniej jedna sztuka i wydaje pieniądze
                                    money_storage = money_storage - P;
                                      while ( money_storage > 0) 
                                   begin
                                  if(money_storage >=50)begin
                                   out_data_reg[1:0] <= in_data[1:0];
                                  out_data_reg = out_data_reg ^ 8'b00000100;
                                  money_storage = money_storage -50;
                                  end else if(money_storage >=20)begin
                                  out_data_reg[1:0] <= in_data[1:0];
                                  out_data_reg = out_data_reg ^ 8'b00001000;
                                  money_storage = money_storage -20;
                                  end else if(money_storage >=10)begin
                                  out_data_reg[1:0] <= in_data[1:0];
                                  out_data_reg = out_data_reg ^ 8'b00010000;
                                  money_storage = money_storage -10;
                                  end else if(money_storage >=5)begin
                                  out_data_reg[1:0] <= in_data[1:0];
                                  out_data_reg= out_data_reg ^ 8'b00100000;
                                  money_storage = money_storage -5;
                                  end else if(money_storage >=2)begin
                                  out_data_reg[1:0] <= in_data[1:0];
                                  out_data_reg = out_data_reg ^ 8'b01000000;
                                  money_storage = money_storage -2;
                                  end else if(money_storage >=1)begin
                                  out_data_reg[1:0] <= in_data[1:0];
                                  out_data_reg = out_data_reg ^ 8'b10000000;
                                  money_storage = money_storage -1;
                                     end
                                      out_data <= out_data_reg;
                                      P_q <= P_q -1;                                                                       
                                     end                          
                                 end
                                 4: case(in_data[7:3]) //Ten case definiuje koszty wybranego produktu np. 200 groszy
                                    0: C <= money_storage;
                                    1: S <= money_storage;
                                    2: P <= money_storage;
                                    endcase
                                 5: case(in_data[4:3]) //Tym casem przypisujemy ilość wybranego produktu
                                    0: C_q <= in_data[7:5];
                                    1: S_q <= in_data[7:5];
                                    2: P_q <= in_data[7:5];
                                    endcase
                                 6:if(money_storage > 0) begin //Wykonując tego case zbieramy resztę jeśli nie ma produktów
                                  if(money_storage >=50)begin
                                  out_data_reg = out_data_reg ^ 8'b00000100;
                                  money_storage = money_storage -50;
                                  end if(money_storage >=20)begin
                                  out_data_reg = out_data_reg ^ 8'b00001000;
                                  money_storage = money_storage -20;
                                  end if(money_storage >=10)begin
                                  out_data_reg = out_data_reg ^ 8'b00010000;
                                  money_storage = money_storage -10;
                                  end if(money_storage >=5)begin
                                  out_data_reg= out_data_reg ^ 8'b00100000;
                                  money_storage = money_storage -5;
                                  end if(money_storage >=2)begin
                                  out_data_reg = out_data_reg ^ 8'b01000000;
                                  money_storage = money_storage -2;
                                  end if(money_storage >=1)begin
                                  out_data_reg = out_data_reg ^ 8'b10000000;
                                  money_storage = money_storage -1;
                                    end
                                    out_data <= out_data_reg;
                                    end                                                                                                   
                                    
                       endcase
                       end
                        
                       end
                                                                     
endmodule   