module Final2023(output reg [7:0] DATA_R, DATA_G, DATA_B,output reg [3:0] COMM,output reg COMM1,COMM2, 
output reg [7:0] seg,output reg [7:0] D,input CLK,Clear, input [3:0] num1,num2, input Enter,output reg beep,output bb);

		bit [2:0] flag;
		bit [2:0] cnt;
		reg[3:0] r1; //十位數
		reg[3:0] r2; //個位數
		reg [3:0]f;
		reg in,h,die;
		
		initial
		begin
		flag = 3'b000;
		cnt = 0;
		DATA_R = 8'b11111111;
		DATA_G = 8'b11111111;
		DATA_B = 8'b11111111;
		COMM = 4'b1000;
		beep = 0;
		D <=8'b00000000;
	 
		COMM1=1'b0;
		COMM2=1'b1;
		f=4'b0001;
		r1=4'b0011;
		r2=4'b0101;
		in=1;
		h=0;
		die=0;
		
		end
		
		divfreq4 F3(CLK, CLK_2t);
		divfreq F0(CLK, CLK_div);
		divfreq2 F1(CLK, CLK_1Hz);
		Randnum(in,CLK, Clear, r1,r2);
		Seg2Timer(COMM1,COMM2,seg,z,h,CLK,Clear);


		
	always@(posedge CLK_2t)
	if(Clear) in=1;
	else in=0;
		
	 always@(posedge CLK_div, posedge Clear)
	 begin
	  if(Clear) 
	  begin
		flag = 3'b000;	
		h=0;
		beep=0;
	  end
	  else
	  begin
	  if(Enter == 1)
	  begin
			if((num1 == r1)&&(num2 == r2)) 
			begin
			flag = 3'b011; 
			h=1;
			beep=1;
			end
			else if((num2 == r2)&&(num1 < r1)) 
			begin
			flag = 3'b001; 
			beep=0;
			end
			else if((num2 < r2))
			begin	
			flag = 3'b001; 
			beep=0;
			end
			else flag = 3'b010;
	  end
	  if(z==1) 
	  begin
	  flag <= 3'b111;
	  beep=1;
	  end
	  end
	 end
		
	parameter logic [7:0] Err_Char [7:0]=
    '{8'b01111110,
     8'b10111101,
     8'b11011011,
     8'b11100111,
     8'b11100111,
     8'b11011011,
     8'b10111101,
     8'b01111110};	
	parameter logic [7:0] Char [7:0]=
		'{8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111};
	parameter logic [7:0] U_Char [7:0]=
	   '{8'b11110111,
    8'b11111011,
    8'b11111101,
	  8'b00000000,
	  8'b00000000,
	  8'b11111101,
	  8'b11111011,
	  8'b11110111};
  parameter logic [7:0] D_Char [7:0]=
     '{8'b11101111,
		8'b11011111,
	  8'b10111111,
	  8'b00000000,
	  8'b00000000,
	  8'b10111111,
	  8'b11011111,
	  8'b11101111};
  
  parameter logic [7:0] H_Char [7:0]=
     '{8'b11110101,
      8'b11101110,
      8'b11011110,
      8'b10111101,
      8'b10111101,
      8'b11011110,
      8'b11101110,
      8'b11110101};
	
  always @(posedge CLK_div)
  begin
  if((flag == 3'b011)||(h==1))
    begin
    if(cnt >= 7)
      cnt = 0;
    else
    cnt = cnt + 1;
    COMM = {1'b1,cnt};
	 DATA_G = Char[cnt];
    DATA_B = H_Char[cnt];
	 DATA_R = H_Char[cnt];
  end
	else if((flag == 3'b111)||(die==1))
    begin
    if(cnt >= 7)
      cnt = 0;
    else
    cnt = cnt + 1;
    COMM = {1'b1,cnt};
	 DATA_B = Err_Char[cnt];
	 DATA_R = Char[cnt];
	 DATA_G = Err_Char[cnt];
	end
    else if(flag == 3'b001)
    begin
    if (cnt >= 7)
      cnt = 0;
    else
      cnt = cnt +1;
    COMM = {1'b1,cnt};
	 DATA_G = U_Char[cnt];
	 DATA_B = Char[cnt];
	 DATA_R = Char[cnt];
	 end
  else if(flag == 3'b010)
    begin
    if(cnt >= 7)
      cnt = 0;
    else
    cnt = cnt + 1;
    COMM = {1'b1,cnt};
	 DATA_G = D_Char[cnt];
	 DATA_B = Char[cnt];
	 DATA_R = Char[cnt];
  end
  else
    begin
    if (cnt >= 7)
      cnt = 0;
    else
      cnt = cnt +1;
    COMM = {1'b1,cnt};
	 DATA_R = Char[cnt];
	 DATA_G = Char[cnt];
	 DATA_B = Char[cnt];
	 end
	end
  
	
	always@(posedge CLK_2t,posedge Clear)
	begin
   if(Clear)
	begin
	D<=8'b11111111;
	die=0;
	f=1;
	end
   else
   begin
	if(Enter==1)
	begin
		if(flag == 3'b111)
		D <=8'b00000000;
     else if(flag == 3'b010||flag == 3'b001)
	  begin 
     if(f==1)begin
       D =8'b11111111;
     f=f+1;
     end
     else if(f==2)begin
       D =8'b11111110;
     f=f+1;
     end
     else if(f==3)begin
       D =8'b11111100;
     f=f+1;
     end
     else if(f==4)begin
       D =8'b11111000;
     f=f+1;
     end  
     else if(f==5)begin
       D =8'b11110000;
     f=f+1;
     end  
     else if(f==6)begin
       D =8'b11100000;
     f=f+1;
     end  
     else if(f==7)begin
       D =8'b11000000;
     f=f+1;
     end  
     else if(f==8)begin
       D =8'b10000000;
     f=f+1;
     end  
     else begin
       D =8'b00000000;
		 die=1;
     end
	end
	end
	end
	end
endmodule	



module divfreq(input CLK, output reg CLK_div);
	reg [24:0] Count;
	always @(posedge CLK)
	  begin
		 if(Count > 25000)
		 begin
		 Count <= 25'b0;
		 CLK_div <= ~CLK_div;
	  end
	  else
		 Count <= Count +1'b1;
	  end
endmodule

module divfreq2(input CLK, output reg CLK_1Hz);
	reg [24:0] Count;
	always @(posedge CLK)
	  begin
		 if(Count > 25000000)
		 begin
		 Count <= 25'b0;
		 CLK_1Hz <= ~CLK_1Hz;
	  end
	  else
		 Count <= Count +1'b1;
	  end
endmodule


module divfreq3(input CLK, output reg CLK_1t);
	reg [24:0] Count;
	always @(posedge CLK)
	  begin
		 if(Count > 4000000)
		 begin
		 Count <= 25'b0;
		 CLK_1t <= ~CLK_1t;
	  end
	  else
		 Count <= Count +1'b1;
	  end
endmodule


module divfreq4(input CLK, output reg CLK_2t);
	reg [24:0] Count;
	always @(posedge CLK)
	  begin
		 if(Count > 18000000)
		 begin
		 Count <= 25'b0;
		 CLK_2t <= ~CLK_2t;
	  end
	  else
		 Count <= Count +1'b1;
	  end
endmodule

module divfreq5(input CLK, output reg CLK_3t);
	reg [24:0] Count;
	always @(posedge CLK)
	  begin
		 if(Count > 2500000)
		 begin
		 Count <= 25'b0;
		 CLK_3t <= ~CLK_3t;
	  end
	  else
		 Count <= Count +1'b1;
	  end
endmodule


module Seg2Timer(output reg COM1,COM2, 
output reg [7:0] seg,output reg Zero, input heart, input CLK,Clear);

	divfreq F0(CLK, CLK_div);
	divfreq2 F1(CLK, CLK_1Hz);
	
	reg [3:0] A_count,B_count;
	initial
		begin
			COM1=1'b0;
			COM2=1'b1;
			A_count=4'b1001;
			B_count=4'b0001;
		end 
	
	always @(posedge CLK_1Hz)
		if(Clear==1)
			begin
				A_count=4'b1001;
				B_count=4'b1001;
			end
		else
		begin
		if((Zero==1)||(heart==1))
			begin
			A_count<=4'b1111;
			B_count<=4'b1111;
			end
		else
			begin
				if(A_count==4'b0000) 
					begin
					A_count <= 4'b1001;
					B_count <= B_count - 1'b1;
					end
				else A_count <= A_count - 1'b1;
			end
		end
	always @(B_count)
	begin
		if(B_count==4'b1111) Zero=1;
		else Zero=0;
	end
	
	always @(posedge CLK_div)
			begin
				COM1<=~COM1;
				COM2<=~COM2;
			end
	
	always @(COM1)
	begin
		if(COM1)
			begin
				case(A_count)
					4'b0000: seg =8'b00000011;
					4'b0001: seg =8'b10011111;
					4'b0010: seg =8'b00100101;
					4'b0011: seg =8'b00001101;
					4'b0100: seg =8'b10011001;
					4'b0101: seg =8'b01001001;
					4'b0110: seg =8'b01000001;
					4'b0111: seg =8'b00011111;
					4'b1000: seg =8'b00000001;
					4'b1001: seg =8'b00001001;
					default: seg =8'b00000011;
				endcase
			end
		else
			begin
				case(B_count)
					4'b0000: seg =8'b00000011;
					4'b0001: seg =8'b10011111;
					4'b0010: seg =8'b00100101;
					4'b0011: seg =8'b00001101;
					4'b0100: seg =8'b10011001;
					4'b0101: seg =8'b01001001;
					4'b0110: seg =8'b01000001;
					4'b0111: seg =8'b00011111;
					4'b1000: seg =8'b00000001;
					4'b1001: seg =8'b00001001;
					default: seg =8'b00000011;
				endcase
			end
	end	
endmodule

module Randnum(input in, CLK, Clear, output reg [3:0] num3,num4);

	reg [3:0] C_count, D_count;
	
	divfreq3 F2(CLK, CLK_1t);
	divfreq5 F4(CLK, CLK_3t);
	
	initial
	begin
		num3=4'b0010;
		num4=4'b0000;
	end
	
	always @(posedge Clear)
	if(in==1)
	begin
	num3 <= C_count;
	num4 <= D_count;
	end
	
	
	always @(posedge CLK_3t)
		begin
			if(C_count==4'b1001) 
				C_count <= 4'b0000;
			else C_count <= C_count + 1'b1;
		end

	always @(posedge CLK_1t)
		begin
			if(D_count==4'b1001) 
				D_count <= 4'b0000;
			else D_count <= D_count + 1'b1;
		end



endmodule
