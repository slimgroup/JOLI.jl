using JOLI
cn=rand(2:4,3)
rm=rand(2:4,3)
A =[joConstants(rm[1],cn[1],1.) joConstants(rm[1],cn[2],2.) joConstants(rm[1],cn[3],3.);
    joConstants(rm[2],cn[2],4.) joConstants(rm[2],cn[3],5.) joConstants(rm[2],cn[1],6.);
    joConstants(rm[3],cn[3],7.) joConstants(rm[3],cn[1],8.) joConstants(rm[3],cn[2],9.)]
showall(A); println()
display(elements(A)); println()
showall(A.'); println()
display(elements(A.')); println()
showall(A'); println()
display(elements(A')); println()
