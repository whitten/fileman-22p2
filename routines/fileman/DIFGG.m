DIFGG	;SFISC/XAK,EDE(OHPRD)-FILEGRAM GENERATOR ;7/25/92  2:15 PM
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
	K DIFG S DIFG=DIC,DIC("A")="Select FILEGRAM TEMPLATE: "
	S DK=+Y,DIC="^DIPT(",DIC("S")="I $P(^(0),U,8)=1 S %=^(0) I $P(%,U,4)=DK!'$L($P(%,U,4))",DIC(0)="QEAIS",D="F"_+Y
	D IX^DIC K DIC,DY Q:Y<0  S (DIFG("TEMPLATE"),DIFGT)=+Y
	S DIC=DIFG,DIC(0)="QEAM" D ^DIC Q:Y<0  S DIFG("FE")=+Y,DIFG("FUNC")="L",DIFG("DUZ")=$S($D(^VA(200,DUZ,0)):$P(^(0),U),$D(^DIC(3,DUZ,0)):$P(^(0),U),1:DUZ)
	D START,SEND,LOG K DIFG,^UTILITY("DIFG",$J) Q
	;
EN	; EXTERNAL ENTRY POINT
START	;
	D INIT
	I DIFG("QFLG") D EOJ Q
	D HDR,ENV,BODY,TLR,EOJ
	Q
	;
HDR	; FILEGRAM HEADER
	S V="$DAT"_U_DIFG(DILL,"FNAME")_U_DIFG(DILL,"FILE")_U_DIFG("PARM")_U
	D INCSET^DIFGGU
	K Y Q
	;
ENV	; ENVIRONMENTAL VARS
	I $D(DIFG("ENV"))
	E  Q
	S DIFG("EV")=""
	F  S DIFG("EV")=$O(DIFG("ENV",DIFG("EV"))) Q:DIFG("EV")=""  S V="ENVIRONMENT:"_DIFG("EV")_"="""_DIFG("ENV",DIFG("EV"))_"""" D INCSET^DIFGGU ;ihs/ohprd/dg;patch 2;8-22-91
	K DIFG("EV") Q
	;
BODY	; FILEGRAM BODY
	D BASE
	K DIFG("NOKEY")
	D NEXTLVL
	Q
	;
BASE	; BASEFILE ENTRY
	D LOOKUP^DIFGGU
	D FIELDS
	Q
	;
NEXTLVL	; DO NEXT LEVEL FILES/SUBFILES (CALLED RECURSIVELY)
	S DIFG(DILL,"DIFGI")=DIFGI
	S DILL=DILL+1
	F DIFGI=DIFGI:0 S DIFGI=$O(^DIPT(DIFGT,1,DIFGI)) Q:DIFGI'=+DIFGI  S X=^(DIFGI,0) D NEXTLVL2 Q:DIFGI=""
	S DILL=DILL-1
	S DIFGI=DIFG(DILL,"DIFGI")
	Q
	;
NEXTLVL2	; CHECK TEMPLATE ENTRY
	I $P(X,U,2)<DILL S DIFGI="" Q
	Q:$P(X,U,3)'=DIFG(DILL-1,"FILE")  ; this is probably a template error
	D FVARS^DIFGGI
	I DIFG(DILL,"XREF")?1A.E D DIFGG3^DIFGG4 Q  ; file shift
	I DIFG(DILL,"XREF")=3 D ^DIFGG4 Q  ; subfile shift
	Q:'DIFG(DILL,"FE")
	; only things left are dinum back pointers, direct forward pointers,
	; and lookup file shifts, I think.
	D LOOKUP^DIFGGU
	I $D(DIFGGUQ) K DIFGGUQ Q
	D FIELDS
	D RECURSE
	S DITAB=2*(DILL-1)
	S V=":" D INCSET^DIFGGU
	Q
	;
RECURSE	; RECURSION FOR DINUM BACK POINTERS AND FORWARD DIRECT POINTERS
	D NEXTLVL
	Q
	;
FIELDS	; FILEGRAM FIELDS
	S DITAB=DITAB+2 D ^DIFGG2 S DITAB=DITAB-2
	Q
	;
LOG	; RECORD THE SENDING
	Q:$D(DIAR)!$D(DY)
	S DIC=1.12,X="NOW",DIC(0)="L",DLAYGO=1.12,DIADD=1 D ^DIC Q:Y<0  G LOG:'$P(Y,U,3)
	S ^DIAR(1.12,+Y,0)=$P(Y,U,2)_"^s^"_DIFG("DUZ")_U_DIFG_U_DIFG("FE")_U_XMZ_U_DIFG("TEMPLATE")
	K DIC,DIE,DR,DA,DLAYGO,DIADD,XMZ
	Q
	;
	;
SEND	; CALL MAILMAN
	Q:$D(DIAR)!$D(DY)
	S XMSUB="FILEGRAM for entry #"_DIFG("FE")_" in "_$O(^DD(DIFG,0,"NM",0))_" FILE (#"_DIFG_")."
	S XMTEXT=DIFG("FGR"),XMDUZ=DUZ D ^XMD
	Q
	;
TLR	; FILEGRAM TRAILER
	S V="$END DAT",DITAB=0
	D INCSET^DIFGGU
	Q
	;
INIT	; INITIALIZATION
	D ^DIFGGI
	Q
	;
EOJ	;
	S:DIFG("QFLG") DIFGER=DIFG("QFLG")
	F I=0:0 S I=$O(DIFG(I)) Q:I'=+I  K DIFG(I)
	K ^UTILITY("DIFGLINK",$J)
	K DIFG2,DIFGI,DIFGT,DILL,DITAB,DIFGENV,DIFGGU,DIFGGF ;Don't kill DILC used by EN^DIFGG;ihs/ohprd/dwg;patch 2;8-22-91
	K %H,%K,%W,S,V,X
	Q
