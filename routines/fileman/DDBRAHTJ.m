DDBRAHTJ	;SFISC/DCL-BROWSER HYPERTEXT JUMP ; 18NOV2012
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	Q
JUMP(DDBRDIR)	; pass direction 1/forward -1/backward
	;
	;
	N DDBSAN,DDBRAFLG,DDBLST
	S DDBSAN=$$NROOT^DDBRAP($NA(@DDBSA)),DDBLST=$NA(^TMP("DDBLST",$J))
	I $G(DDBRDIR)=1 D FRWD Q
	D BCK
	Q
FRWD	; forward
	Q:'$$CHKI
	N DDBRAHP,DDBRAHA,DDBSANX,DDBRAAH,DDBRAHL,DDBRSET,DIERM
	S DDBSANX=$P(DDBRHT,DDGLDEL,2),DDBRAAH=$P(DDBSANX,"^"),DDBRSET=1
	;jump to another root
	I DDBSANX["$CREF$" D  G STKPT:DDBSANX]"" G PS^DDBR2
	.N DDBRAB,DDBRABR,DDBLSTN,DDBRATR,DDBRANRT,DDBRXC2,DDBRXC3
	.S DDBRATR=$P(DDBSANX,"$CREF$",2)
	.S DDBRAAH=$P($P(DDBSANX,"$CREF$",3),"^")
	.I DDBRATR="" S DDBRAAH="" Q
	.I $D(@DDBRATR)'>9,$E($G(@DDBRATR),1,5)="$XC$^" D  Q:$D(@DDBRATR)'>9
	..N X,DDBRNR
	..S DDBRXC3=$P(@DDBRATR,"$XC$^",3)
	..S X(1)="",X(2)=$$CTXT^DDBR("Loading "_DDBRXC3,"",IOM),X(3)=""
	..W $$WS^DDBR1(.X)
	..S DDBRXC2=$P(@DDBRATR,"$XC$^",2) X DDBRXC2
	..I $D(@DDBRATR)'>9 Q
	..I DDBRXC3]"" D WP^DDBRAP(DDBRATR,"",DDBRXC3)
	..Q
	.I $D(@DDBRATR)'>9,$E($G(@DDBRATR),1,6)="$XCR$^" D  W @IOSTBM Q
	..N X,IOTM,IOBM,IOSTBM
	..S DDBRXC2=$P(@DDBRATR,"$XCR$^",2),DDBSANX="" X DDBRXC2
	..W:$D(IOF) @IOF
	..S X=0 X ^DD("OS",DISYS,"RM")
	..W $P(DDGLVID,DDGLDEL,8)
	..Q
	.I '$D(@DDBRATR) S DDBRAAH="" Q
	.S DDBRANRT=$$NROOT^DDBRAP(DDBRATR)
	.I '$D(@DDBRANRT) D WP^DDBRAP(DDBRATR)
	.S DDBLSTN=$S($D(@DDBLST@("A",DDBSA)):^(DDBSA),1:$O(@DDBLST@(" "),-1)+1)
	.D SAVEDDB^DDBR2(DDBLST,DDBLSTN,1),SET
	.S DDBRSET=0
	.S DDBRAAH=$P(DDBRAAH,"#",2),DDBRAFLG=1
	.S DDBSA=DDBRATR,DDBSAN=DDBRANRT
UP	.S DDBPMSG=$G(@DDBSAN@("TITLE")) S:DDBPMSG="" DDBPMSG=$$UP^DILIBF($P(DDBSANX,"^",$L(DDBSANX,"^"))) ;**
	.D SAVSET
	.Q
	;jump to another file, w-pDD#,entry:entry#anchor
	I DDBRAAH,DDBRAAH["@" D  G STKPT
	.N DDBRAB,DDBRABR,DDBLSTN,DDBRATR,DDBRANRT
	.S DDBRAB=$P(DDBRAAH,"#")
	.I DDBRAB="" S DDBRAAH="" Q
	.S DDBRATR=$$GETR^DDBRAP($P(DDBRAB,"@"),$P($P(DDBRAB,"@",2),"#"))
	.I DDBRATR="" D  Q
	..S DDBRAAH=""
	..I $G(DIERR) S DIERM=$$CTXT^DDBR($G(^TMP("DIERR",$J,+DIERR,"TEXT",1)))
	..K DIERR,^TMP("DIERR",$J)
	..Q
	.S DDBRANRT=$$NROOT^DDBRAP(DDBRATR)
	.I '$D(@DDBRANRT) D WP^DDBRAP(DDBRATR)
	.S DDBLSTN=$S($D(@DDBLST@("A",DDBSA)):^(DDBSA),1:$O(@DDBLST@(" "),-1)+1)
	.D SAVEDDB^DDBR2(DDBLST,DDBLSTN,1),SET
	.S DDBRSET=0
	.S DDBRAAH=$P(DDBRAAH,"#",2),DDBRAFLG=1
	.S DDBSA=DDBRATR,DDBSAN=DDBRANRT
	.S DDBPMSG=$G(@DDBSAN@("TITLE")) S:DDBPMSG="" DDBPMSG="HYPERTEXT JUMP ID#"_$O(@DDBLST@("J",""),-1)+1
	.D SAVSET
	.Q
	;jump to another entry in the same file, same level
	I DDBRAAH["#",$P(DDBRAAH,"#")]"" D
	.N DDBRAB,DDBRABR,DDBRAIEN,DDBLSTN,DDBRALEV,DDBRANRT
	.S DDBRAB=$P(DDBRAAH,"#")
	.I DDBRAB="" S DDBRAAH="" Q
	.S DDBRALEV="",DDBRABR=$$IENROOT^DDBRAP($NA(@DDBSA),.DDBRALEV)
	.S DDBRAIEN=$O(@DDBRABR@("B",DDBRAB,""))
	.I 'DDBRAIEN S DDBRAAH="" Q
	.S DDBRANRT=$$NROOT^DDBRAP($NA(@DDBRABR@(DDBRAIEN,DDBRALEV)))
	.I '$D(@DDBRANRT) D WP^DDBRAP($NA(@DDBRABR@(DDBRAIEN,DDBRALEV)))
	.S DDBLSTN=$S($D(@DDBLST@("A",DDBSA)):^(DDBSA),1:$O(@DDBLST@(" "),-1)+1)
	.D SAVEDDB^DDBR2(DDBLST,DDBLSTN,1),SET
	.S DDBRSET=0
	.S DDBRAAH=$P(DDBRAAH,"#",2),DDBRAFLG=1
	.S DDBSA=$NA(@DDBRABR@(DDBRAIEN,DDBRALEV))
	.S DDBSAN=DDBRANRT
	.S DDBPMSG=$G(@DDBSAN@("TITLE")) S:DDBPMSG="" DDBPMSG="HYPERTEXT JUMP ID#"_$O(@DDBLST@("J",""),-1)+1
	.D SAVSET
	.Q
STKPT	S:DDBRAAH["#" DDBRAAH=$P(DDBRAAH,"#",2)
	I DDBRAAH]"" S DDBRAHA=$G(@DDBSAN@("A",DDBRAAH))
	I DDBRSET,$G(DDBRAHA)'>0 D NOHTJ($G(DIERM)) G PS^DDBR2
	S DDBRAHL=$S($G(DDBRAHA):DDBRAHA+DDBSRL-1,1:0)
	D SET:DDBRSET,GOTO Q
	Q
	;
SET	; set and save jump info
	S DDBRAHP=$O(@DDBLST@("J",""),-1)+1
	S @DDBLST@("J",DDBRAHP)=DDBSA_DDGLDEL_DDBL_"^"_+$G(DDBLSTN)_DDGLDEL_DDBRHT
	Q
	;
GOTO	; jump to line in current document
	S DDBL=$S(DDBRAHL'>DDBSRL:0,DDBRAHL>DDBTL:DDBTL,1:DDBRAHL) D PSR^DDBR0(+$G(DDBRAFLG))
	Q
BCK	; backward
	Q:'$D(@DDBLST@("J"))
	N DDBX,DDBY,DDBRAFLG
	S DDBX=$O(@DDBLST@("J",""),-1),DDBY=@DDBLST@("J",DDBX)
	K @DDBLST@("J",DDBX)
	I $P(DDBY,DDGLDEL)'=DDBSA D  S DDBRAFLG=1
	.D USAVEDDB^DDBR2(DDBLST,$P($P(DDBY,DDGLDEL,2),"^",2))
	S DDBL=+$P(DDBY,DDGLDEL,2),DDBRHT=$P(DDBY,DDGLDEL,3,255)
	D PSR^DDBR0(+$G(DDBRAFLG))
	Q
CHKI()	;return 1 if ok 0 not ok to continue also init DDBRHT if undefined
	S DDBRHT=$G(DDBRHT)
	Q:DDBRHT="" 0
	I $P(DDBRHT,DDGLDEL,4)'=DDBSA Q 0
	I +DDBRHT>DDBL Q 0
	I +DDBRHT<($S(DDBL'>DDBSRL:0,1:DDBL-DDBSRL)+1) Q 0
	Q 1
	;
NOHTJ(EM)	; no hypertext jump available
	N X,Y
	S Y=$P(DDBSANX,"^",$S(DDBSANX["$CREF$":$L(DDBSANX,"^"),1:2)),X(1)=$$CTXT^DDBR(Y,"",IOM),EM=$G(EM) S:$P(EM,"Error:",2)]"" EM="<< "_$P(EM,"Error:",2)_" >>"
	S X(2)=""
	S X(3)=$$CTXT^DDBR($S(EM]"":EM,1:"<< "_$$EZBLD^DIALOG(7077)_" >>"),"",IOM) ;**NO HYPERTEXT JUMP
	W $$WS^DDBR1(.X),$C(7)
	R X:5
	Q
	;
SAVSET	;
	S DDBHDR=$$CTXT^DDBR(DDBPMSG,$J("",IOM+1),IOM)
	S DDBTL=$P($G(@DDBSA@(0)),"^",3) S:DDBTL'>0 DDBTL=$O(@DDBSA@(" "),-1)
	S DDBTPG=DDBTL\DDBSRL+(DDBTL#DDBSRL'<1)
	S DDBZN=$D(@DDBSA@(DDBTL,0))#2
	S DDBDM=0
	S DDBSF=1
	S DDBST=IOM
	S DDBC=$NA(^TMP("DDBC","DDBC",$J))
	I '$D(@DDBC) F I=1,22:22:176 S @DDBC@(I)=""
	Q
