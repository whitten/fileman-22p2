DDGLCBOX	;SFISC/MKO-COMBO BOX ;2:09 PM  26 Apr 1996
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
	;
CBOX(DDGLGLO,DDGLOUT,DDGLROW,DDGLCOL,DDGLHT,DDGLWD,DDGLSEL,DDGLFLG)	;
	Q:$G(DDGLGLO)=""
	;
	N DDGLCBOX,DDGLSEL,DDGLI,DDGLNC,DDGLEMAP,DDGLTERM,DDGLDONE
	;
	;Create list box and set up defaults
	D INIT
	;
	;Save the # columns and selected text
	S DDGLI=DDGLCBOX(DDGLCBOX,"SV")
	S DDGLNC=$P(DDGLI,U,5)
	S DDGLSEL=DDGLCBOX(DDGLCBOX,"ITEM",$P(DDGLI,U,6))
	K DDGLI
	;
	;Write the brackets for the edit field
	S DY=DDGLROW,DX=DDGLCOL X IOXY
	W "["_$J("",DDGLNC)_"]"
	;
	;Read for the edit box
	S DDGLEMAP(1)="EKDN^DDGLCBOX;KEYDOWN"
	S DDGLEMAP(2)="EQUIT^DDGLCBOX;$C(27,27)"
	S DDGLEMAP(3)="EQUIT^DDGLCBOX;F1_""Q"""
	S DDGLEMAP(4)="EQUIT^DDGLCBOX;F1_""C"""
	S DDGLEMAP(5)="EEXIT^DDGLCBOX;F1_""E"""
	;
	F  D  Q:$G(DDGLDONE)
	. D EN^DIR0(DDGLROW,DDGLCOL+1,DDGLNC,1,DDGLSEL,245,0,.DDGLEMAP,"KTW",.DDGLSEL,.DDGLTERM)
	. I $P(DDGLTERM,U)="N" S DDGLDONE=1 Q
	. I $P(DDGLTERM,U)="QUIT" S DDGLDONE=1 Q
	. I $P(DDGLTERM,U)="TO" S DDGLDONE=1 Q
	. ;
	. D READ^DDGLBXA(.DDGLCBOX,.DDGLOUT)
	. I DDGLOUT("C")'="TAB" S DDGLDONE=1 Q
	. S DDGLSEL=DDGLOUT(0)
	;
	;Clear edit field and destroy list box
	S DY=DDGLROW,DX=DDGLCOL X IOXY
	W $J("",DDGLNC+2)
	D DESTROY^DDGLBXA(DDGLCBOX,$G(DDGLFLG))
	Q
	;
EKDN	;
	Q:"^UP^DOWN^RIGHT^LEFT^TAB^"[(U_Y_U)
	;
	D E1^DIR01
	S DIR0CH=""
	Q:DIR0A=""
	;
	N DDGLDX,DDGLDY
	W $P(DDGLVID,DDGLDEL,10)
	S DDGLDX=DX,DDGLDY=DY
	;
	D UPDATE^DDGLBXA(.DDGLCBOX,DIR0A)
	;
	W $P(DDGLVID,DDGLDEL,6)
	S DX=DDGLDX,DY=DDGLDY
	Q
EQUIT	;
	S DIR0QT="1^QUIT"
	Q
EEXIT	;
	S DIR0QT="1^N"
	Q
LTAB	;
	K DDGLOUT
	S DDGLOUT=$O(@DDGLGLO@(DDGLSEL,"")),DDGLOUT(0)=DDGLSEL
	S DDGLOUT("C")="TAB"
	S DDGLQT=1
	Q
	;
LKDN	;
	N DY,DX
	S DY=DDGLROW-1,DX=DDGLCOL X IOXY
	W DDGLSEL_$J("",DDGLNC-$L(DDGLSEL))
	Q
	;
INIT	;Set defaults and create list box
	;Returns:  DDGLCBOX array
	;
	D INIT^DDGLIB0()
	;
	;Set defaults for row and column
	N DDGLMAP
	I $G(DDGLROW,-1)<0 S DDGLROW=5
	E  I DDGLROW+4>IOSL S DDGLROW=IOSL-4
	I $G(DDGLCOL,-1)<0 S DDGLCOL=5
	E  I DDGLCOL+6>IOM S DDGLCOL=IOM-6
	;
	;Check DDGLHT and DDGLWD
	S DDGLHT=$S($D(DDGLHT)[0:7,DDGLHT<3:3,1:DDGLHT)
	S:DDGLROW+DDGLHT+2>IOSL DDGLHT=IOSL-DDGLROW
	;
	S DDGLWD=$S($D(DDGLWD)[0:14,DDGLWD<5:5,1:DDGLWD)
	S:DDGLCOL+DDGLWD+2>IOM DDGLWD=IOM-DDGLCOL
	;
	S DDGLMAP(1)="LTAB^DDGLCBOX;$C(9)"
	S DDGLMAP(2)="LKDN^DDGLCBOX;KEYDOWN"
	;
	D CREATE^DDGLBXA(DDGLGLO,.DDGLCBOX,DDGLROW+1,DDGLCOL+1,DDGLHT,DDGLWD,$G(DDGLSEL),.DDGLMAP)
	Q
	;
