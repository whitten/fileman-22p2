DDW3	;SFISC/MKO-TOP, BOTTOM, SCROLL ;11:57 AM  24 Aug 2002
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;
TOP	N DDWI
	I DDWA=0 D POS(1,1,"RN") Q
	D SHFTUP(1),POS(1,1,"RN")
	Q
	;
SHFTUP(DDWFL)	;
	N DDWSH,DDWI
	S DDWSH=DDWA+1-DDWFL
	D:DDWSH>DDWMR MSG^DDW(" ...") ;**
	;
	F DDWI=DDWMR:-1:$$MAX(1,DDWMR-DDWSH+1) D:DDWI+DDWA'>DDWCNT
	. S DDWSTB=DDWSTB+1,^TMP("DDW1",$J,DDWSTB)=DDWL(DDWI)
	. S ^TMP("DDW",$J,DDWA+DDWI)=DDWL(DDWI)
	;
	I $E(DDWBF,2) F DDWI=DDWA:-1:DDWFL+DDWMR D
	. S DDWSTB=DDWSTB+1
	. S ^TMP("DDW1",$J,DDWSTB)=^TMP("DDW",$J,DDWI)
	E  S DDWSTB=$$MAX(DDWCNT-DDWFL+1-DDWMR,0)
	;
	S DDWA=DDWFL-1
	I DDWSH>DDWMR D
	. F DDWI=1:1:DDWMR S DDWL(DDWI)=^TMP("DDW",$J,DDWFL+DDWI-1)
	. I $P(DDWOFS,U,4)=1 D
	.. D CUP(1,1)
	.. F DDWI=1:1:DDWMR W $P(DDGLCLR,DDGLDEL)_$$LINE(DDWI,$G(DDWMARK))_$S(DDWI<DDWMR:$C(13,10),1:"")
	. D MSG^DDW()
	E  D
	. F DDWI=DDWMR:-1:DDWSH+1 S DDWL(DDWI)=DDWL(DDWI-DDWSH)
	. F DDWI=DDWSH:-1:1 S DDWL(DDWI)=^TMP("DDW",$J,DDWFL+DDWI-1)
	. D:$P(DDWOFS,U,4)=1 SCRDN(DDWSH)
	;
	S:'DDWA $E(DDWBF,2)=0
	Q
	;
BOT	N DDWI
	I DDWSTB=0 D POS($$MIN(DDWMR,DDWCNT-DDWA),"E","RN") Q
	D SHFTDN($$MAX(1,DDWCNT-DDWMR+1))
	D POS(DDWMR,"E","RN")
	Q
	;
SHFTDN(DDWFL,DDWCOL)	;
	N DDWNSTB,DDWSH,DDWI
	S DDWSH=DDWFL-DDWA-1,DDWNSTB=DDWCNT-DDWFL+1
	D:DDWSH>DDWMR MSG^DDW(" ...") ;**
	;
	F DDWI=1:1:$$MIN(DDWSH,DDWMR) D
	. S DDWA=DDWA+1,^TMP("DDW",$J,DDWA)=DDWL(DDWI)
	. S ^TMP("DDW1",$J,DDWSTB+DDWMR-DDWI+1)=DDWL(DDWI)
	.
	;
	I $E(DDWBF,3) F DDWI=DDWSTB:-1:DDWNSTB+1 D
	. S DDWA=DDWA+1
	. S ^TMP("DDW",$J,DDWA)=^TMP("DDW1",$J,DDWI)
	E  S DDWA=DDWFL-1
	;
	I DDWSH>DDWMR D
	. F DDWI=1:1:DDWMR S DDWL(DDWI)=$S(DDWNSTB-DDWI+1>0:^TMP("DDW1",$J,DDWNSTB-DDWI+1),1:"")
	. I $P(DDWOFS,U,4)=$$SCR($S($D(DDWCOL):DDWCOL,1:$L(DDWL(DDWMR))+1)) D
	.. D CUP(1,1)
	.. F DDWI=1:1:DDWMR W $P(DDGLCLR,DDGLDEL)_$$LINE(DDWI,$G(DDWMARK))_$S(DDWI<DDWMR:$C(13,10),1:"")
	. D MSG^DDW()
	E  D
	. F DDWI=1:1:DDWMR-DDWSH S DDWL(DDWI)=DDWL(DDWI+DDWSH)
	. F DDWI=DDWMR-DDWSH+1:1:DDWMR S DDWL(DDWI)=$S(DDWNSTB-DDWI+1>0:^TMP("DDW1",$J,DDWNSTB-DDWI+1),1:"")
	. D:$P(DDWOFS,U,4)=$$SCR($L(DDWL(DDWMR))+1) SCRUP(DDWSH)
	;
	S DDWSTB=$$MAX(0,DDWNSTB-DDWMR)
	S:'DDWSTB $E(DDWBF,3)=0
	Q
	;
MVFWD(DDWNUM)	;
	N DDWI
	F DDWI=1:1:DDWNUM D
	. S DDWA=DDWA+1,^TMP("DDW",$J,DDWA)=DDWL(DDWI)
	. S ^TMP("DDW1",$J,DDWSTB+DDWMR-DDWI+1)=DDWL(DDWI)
	F DDWI=1:1:DDWMR-DDWNUM S DDWL(DDWI)=DDWL(DDWI+DDWNUM)
	F DDWI=DDWMR-DDWNUM+1:1:DDWMR D
	. S DDWL(DDWI)=^TMP("DDW1",$J,DDWSTB),DDWSTB=DDWSTB-1
	D SCRUP(DDWNUM)
	Q
	;
SCRUP(DDWNUM)	;
	N DDWI
	D CUP(DDWMR,1)
	F DDWI=DDWMR-DDWNUM+1:1:DDWMR D
	. I $P(DDGLED,DDGLDEL,2)]"" W $C(10)
	. E  D
	.. D CUP(1,1) W $P(DDGLED,DDGLDEL,4)
	.. D CUP(DDWMR,1) W $P(DDGLED,DDGLDEL,3)
	. I DDWL(DDWI)'?." " D
	.. D CUP(DDWMR,1)
	.. W $$LINE(DDWI,$G(DDWMARK))
	D POS(DDWMR,DDWC,"RN")
	Q
	;
MVBCK(DDWNUM)	;
	N DDWI
	F DDWI=DDWMR:-1:DDWMR-DDWNUM+1 D:DDWI+DDWA'>DDWCNT
	. S DDWSTB=DDWSTB+1,^TMP("DDW1",$J,DDWSTB)=DDWL(DDWI)
	. S ^TMP("DDW",$J,DDWA+DDWI)=DDWL(DDWI)
	F DDWI=DDWMR:-1:DDWNUM+1 S DDWL(DDWI)=DDWL(DDWI-DDWNUM)
	F DDWI=DDWNUM:-1:1 S DDWL(DDWI)=^TMP("DDW",$J,DDWA),DDWA=DDWA-1
	D SCRDN(DDWNUM)
	Q
	;
SCRDN(DDWNUM)	;
	N DDWI
	D CUP(1,1)
	F DDWI=DDWNUM:-1:1 D
	. I $P(DDGLED,DDGLDEL,2)]"" W $P(DDGLED,DDGLDEL)
	. E  D
	.. D CUP(DDWMR,1) W $P(DDGLED,DDGLDEL,4)
	.. D CUP(1,1) W $P(DDGLED,DDGLDEL,3)
	. I DDWL(DDWI)'?." " D
	.. D CUP(1,1)
	.. W $$LINE(DDWI,$G(DDWMARK))
	D POS(1,DDWC,"RN")
	Q
	;
ERR	;
	W $C(7)
	Q
	;
CUP(Y,X)	;
	S DY=IOTM+Y-2,DX=X-1 X IOXY
	Q
	;
POS(R,C,F)	;Pos cursor based on char pos C
	N DDWX
	S:$G(C)="E" C=$L($G(DDWL(R)))+1
	S:$G(F)["N" DDWN=$G(DDWL(R))
	S:$G(F)["R" DDWRW=R,DDWC=C
	;
	S DDWX=C-DDWOFS
	I DDWX>IOM!(DDWX<1) D SHIFT(C,.DDWOFS)
	S DY=IOTM+R-2,DX=C-DDWOFS-1 X IOXY
	Q
	;
SHIFT(C,DDWOFS)	;
	N DDWI,N,M,S
	S N=$P(DDWOFS,U,2),M=$P(DDWOFS,U,3)
	S S=$$SCR(C)
	S DDWOFS=S-1*M_U_N_U_M_U_S
	D RULER
	F DDWI=1:1:$$MIN(DDWMR,DDWCNT) D
	. S DY=IOTM+DDWI-2,DX=0 X IOXY
	. W $P(DDGLCLR,DDGLDEL)_$$LINE(DDWI,$G(DDWMARK))
	Q
	;
RULER	;Write ruler
	D CUP(DDWMR+1,1)
	W $P(DDGLCLR,DDGLDEL)_$E(DDWRUL,1+DDWOFS,IOM+DDWOFS)
	I DDWLMAR-DDWOFS'<1,DDWLMAR-DDWOFS'>IOM D
	. D CUP(DDWMR+1,DDWLMAR-DDWOFS) W "<"
	I DDWRMAR-DDWOFS'<1,DDWRMAR-DDWOFS'>IOM D
	. D CUP(DDWMR+1,DDWRMAR-DDWOFS) W ">"
	Q
	;
LINE(DDWI,DDWMARK)	;
	N DDWX
	S DDWX=$E(DDWL(DDWI),1+DDWOFS,IOM+DDWOFS)
	Q:$G(DDWMARK)="" DDWX
	;
	N DDWR1,DDWC1,DDWR2,DDWC2
	S DDWR1=$P(DDWMARK,U,1),DDWC1=$P(DDWMARK,U,2)
	S DDWR2=$P(DDWMARK,U,3),DDWC2=$P(DDWMARK,U,4)
	;
	I DDWI'<(DDWR1-DDWA),DDWI'>(DDWR2-DDWA) D
	. N DDWX1,DDWX2
	. S DDWX1=$S(DDWI=(DDWR1-DDWA):DDWC1,1:1)
	. S DDWX2=$S(DDWI=(DDWR2-DDWA):DDWC2,1:999)
	. S DDWX=$E(DDWL(DDWI),1+DDWOFS,DDWX1-1)_$P(DDGLVID,DDGLDEL,6)_$E(DDWL(DDWI),$$MAX(DDWX1,1+DDWOFS),$$MIN(DDWX2,IOM+DDWOFS))_$P(DDGLVID,DDGLDEL,10)_$E(DDWL(DDWI),$$MAX(DDWX2+1,1+DDWOFS),IOM+DDWOFS)
	Q DDWX
	;
SCR(C)	;
	Q C-$P(DDWOFS,U,2)-1\$P(DDWOFS,U,3)+1
	;
MIN(X,Y)	;
	Q $S(X<Y:X,1:Y)
	;
MAX(X,Y)	;
	Q $S(X>Y:X,1:Y)
