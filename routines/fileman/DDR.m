DDR	;ALB/MJK,SF/DCM-FileMan Delphi Components' RPCs ;4/28/98  10:38
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	Q
LISTC(DDRDATA,DDR)	; -- broker callback to get list data
	N DDRFILE,DDRIENS,DDRFLDS,DDRMAX,DDRFROM,DDRPART,DDRXREF,DDRSCRN,DDRID,DDRVAL,DDRERR,DDRRSLT,DDRFLD,DDRFLAGS,DDROPT,DDROUT
	; -- parse array to parameters
	D PARSE(.DDR)
	S DDRPART=$TR(DDRPART,$C(13)_$C(10),"")
	; -- get specific field criteria
	IF $G(DDR("DDFILE")),$G(DDR("DDFIELD")),$D(^DD(DDR("DDFILE"),DDR("DDFIELD"),12.1)) D
	. N DIC X ^(12.1) S:$D(DIC("S")) DDRSCRN=DIC("S")
	I 'XWBAPVER D V0 Q
	I XWBAPVER>0 D V1 Q
	Q
	;
DIC	D LIST^DIC(DDRFILE,DDRIENS,DDRFLDS,DDRFLAGS,DDRMAX,.DDRFROM,DDRPART,DDRXREF,DDRSCRN,DDRID,DDROUT,"DDRERR")
	Q
	;
V0	S DDROUT="DDRRSLT",DDRFLAGS=$G(DDRFLAGS)_"P",DDRFLDS=$G(DDRFLDS)_";@"
	D DIC
	N Y,I,N S N=0
	I $G(DDRFROM)]"" D SET("[Misc]"),SET("MORE"_U_DDRFROM_U_DDRFROM("IEN"))
	I $D(DDRRSLT("DILIST")) D
	. D SET("[Data]")
	. S I=0 F  S I=$O(DDRRSLT("DILIST",I)) Q:'I  D SET(DDRRSLT("DILIST",I,0))
	IF $D(DDRERR) D SET("[Errors]")
	S X=$$STYPE^XWBTCPC("ARRAY")
	Q
	;
V1	S DDROUT=""
	I XWBAPVER=1,DDRFLAGS["P" S DDRFLAGS=DDRFLAGS_"S" ;only P flag is sent from client for V1 of FMCD
	D DIC
	I $G(DDRFLAGS)["P" D  Q
	. I $D(^TMP("DILIST",$J)) D
	. . N END S END=+^TMP("DILIST",$J,0)
	. . I XWBAPVER>1 S ^(.3)="[MAP]",^TMP("DILIST",$J,.4)=^TMP("DILIST",$J,0,"MAP")
	. . K ^TMP("DILIST",$J,0) S ^(.5)="[BEGIN_diDATA]",^(END+1)="[END_diDATA]"
	. D 11,31
	. S DDRDATA=$NA(^TMP("DILIST",$J))
	. Q
	I $G(DDRFLAGS)'["P" D 11,UNPACKED,31 S DDRDATA=$NA(^TMP("DILIST",$J)) Q
	Q
11	I $G(DDRFROM)]"" S ^TMP("DILIST",$J,.1)="[Misc]",^(.2)="MORE"_U_DDRFROM_U_DDRFROM("IEN")_$S(XWBAPVER>1:U_$P($G(^TMP("DILIST",$J,0)),U,4),1:"")
	Q
31	I $D(DIERR) D ERROR
	Q
SET(X)	;
	S N=N+1
	S DDRDATA(N)=X
	Q
PARSE(DDR)	; -- array parsing
	S DDRFILE=$G(DDR("FILE"))
	S DDRIENS=$G(DDR("IENS"))
	S DDRFLDS=$G(DDR("FIELDS"))
	S DDRFLAGS=$G(DDR("FLAGS"))
	S DDRMAX=$G(DDR("MAX"),"*")
	M DDRFROM=DDR("FROM")
	S DDRPART=$G(DDR("PART"))
	S DDRXREF=$G(DDR("XREF"))
	S DDRSCRN=$G(DDR("SCREEN"))
	S DDRID=$G(DDR("ID"))
	S DDROPT=$G(DDR("OPTIONS"))
	Q
ERROR	;
	N I S I=1
	D Z("[BEGIN_diERRORS]")
	N A S A=0 F  S A=$O(DDRERR("DIERR",A)) Q:'A  D
	. N HD,PARAM,B,C,TEXT,TXTCNT,D,FILE,FIELD,IENS
	. S HD=DDRERR("DIERR",A)
	. I $D(DDRERR("DIERR",A,"PARAM",0)) D
	. . S (B,D)=0 F C=1:1 S B=$O(DDRERR("DIERR",A,"PARAM",B)) Q:B=""  D
	. . . I B="FILE" S FILE=DDRERR("DIERR",A,"PARAM","FILE")
	. . . I B="FIELD" S FIELD=DDRERR("DIERR",A,"PARAM","FIELD")
	. . . I B="IENS" S IENS=DDRERR("DIERR",A,"PARAM","IENS")
	. . . S D=D+1,PARAM(D)=B_U_DDRERR("DIERR",A,"PARAM",B)
	. S C=0 F  S C=$O(DDRERR("DIERR",A,"TEXT",C)) Q:'C  S TEXT(C)=DDRERR("DIERR",A,"TEXT",C),TXTCNT=C
	. S HD=HD_U_TXTCNT_U_$G(FILE)_U_$G(IENS)_U_$G(FIELD)_U_$G(D) D Z(HD)
	. S B=0 F  S B=$O(PARAM(B)) Q:'B  S %=PARAM(B) D Z(%)
	. S B=0 F  S B=$O(TEXT(B)) Q:'B  S %=TEXT(B) D Z(%)
	. Q
	D Z("[END_diERRORS]")
	Q
Z(%)	;
	S ^TMP("DILIST",$J,"ZERR",I)=%,I=I+1 Q
	;
UNPACKED	;
	Q:'$D(^TMP("DILIST",$J))
	N COUNT,IXCNT
	S COUNT=+^TMP("DILIST",$J,0) Q:'COUNT
	I XWBAPVER>1 S ^TMP("DILIST",$J,.3)="[MAP]",^TMP("DILIST",$J,.4)=^TMP("DILIST",$J,0,"MAP")
	K ^TMP("DILIST",$J,0)
	S ^TMP("DILIST",$J,.5)="[BEGIN_diDATA]"
	I XWBAPVER=1 D IX1
	D IENS,FLDS,WID,END
	Q
IX1	I DDROPT["IX",$D(^TMP("DILIST",$J,1)) D
	. S ^TMP("DILIST",$J,1,COUNT+1)="END_IXVALUES" D  S ^(.1)="BEGIN_IXVALUES",^(.2)=IXCNT
	. . N Z S Z=0,IXCNT=0 I $G(^TMP("DILIST",$J,1,1))]"" S IXCNT=1 Q
	. . F  S Z=$O(^TMP("DILIST",$J,1,1,Z)) Q:'Z  S IXCNT=IXCNT+1
	I DDROPT'["IX" K ^TMP("DILIST",$J,1)
	Q
IENS	I $D(^TMP("DILIST",$J,2)) D
	.  S ^TMP("DILIST",$J,2,.1)="BEGIN_IENs",^(COUNT+1)="END_IENs"
	Q
FLDS	I DDRFLDS]"",$D(^TMP("DILIST",$J,"ID")) D
	. N Z,FLD,FLDCNT S FLD="",(Z,FLDCNT,I)=0
	. ;I XWBAPVER>1,DDRFLDS["IX" D
	. ;. F  S I=$O(^TMP("DILIST",$J,"ID",1,0,I)) Q:'I  S IXCNT=IXCNT+1
	. ;. S ^TMP("DILIST",$J,"ID",0,0)="IXCNT="_IXCNT Q
	. F  S Z=$O(^TMP("DILIST",$J,"ID",1,Z)) Q:'Z   S FLD=FLD_Z_";",FLDCNT=FLDCNT+1
	. Q:'FLDCNT
	. S ^TMP("DILIST",$J,"ID",0)="BEGIN_IDVALUES"
	. I XWBAPVER=1 S ^TMP("DILIST",$J,"ID",.1)=FLD_U_FLDCNT
	. S ^TMP("DILIST",$J,"ID",COUNT+1)="END_IDVALUES"
	E  D
	. N Z S Z=0 F  S Z=$O(^TMP("DILIST",$J,"ID",Z)) Q:'Z  K ^TMP("DILIST",$J,"ID",Z)
	Q
WID	I (DDROPT["WID")!(DDRFLDS["WID"),$D(^TMP("DILIST",$J,"ID","WRITE")) D
	. N Z,N,I,IEN,WIDCNT S (N,I)=0
	. M Z=^TMP("DILIST",$J,"ID","WRITE") K ^TMP("DILIST",$J,"ID","WRITE")
	. S ^TMP("DILIST",$J,"ID","WID",0)="BEGIN_WIDVALUES",N=N+1
	. F  S I=$O(Z(I)) Q:'I  S IEN=$G(^TMP("DILIST",$J,2,I)) D
	. . N J S (J,WIDCNT)=0 F  S J=$O(Z(I,J)) Q:'J  S WIDCNT=WIDCNT+1
	. . S ^TMP("DILIST",$J,"ID","WID",N)="WID"_U_IEN_U_WIDCNT,N=N+1
	. . N J S J=0 F J=1:1:WIDCNT S ^TMP("DILIST",$J,"ID","WID",N)=Z(I,J),N=N+1
	. S ^TMP("DILIST",$J,"ID","WID",N)="END_WIDVALUES"
	I (DDROPT'["WID")&(DDRFLDS'["WID") K ^TMP("DILIST",$J,"ID","WRITE")
	Q
END	S ^TMP("DILIST",$J,"IDZ")="[END_diDATA]"
	Q
