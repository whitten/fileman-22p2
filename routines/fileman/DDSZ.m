DDSZ	;SFISC/MKO-FORM COMPILER ;17JUN2004
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;
	;Prompt, compile
	N DDSFRM,DDSDDP,DDSREFS
	N C,DIC,X,Y
	I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
	;
	S DIC="^DIST(.403,",DIC(0)="AEQZ"
	D ^DIC K DIC Q:Y=-1!'$D(^DIST(.403,+Y,0))
	S DDSFRM=Y,DDSDDP=$P(Y(0),U,8)
	;
	W !!,"Compiling "_$P(Y,U,2)_" (#"_+Y_") ...",!
	D EN(DDSFRM,DDSDDP)
	I $G(DIERR) W $C(7) D MSG^DIALOG("BW")
	Q
	;
ALL	;Compile all forms
	N DDSFRM,DDSDDP,DDSFNUM,DDSREFS
	I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
	W:'$D(DDSQUIET) !,"Compiling all forms ...",!
	;
	S DDSFNUM=0
	F  S DDSFNUM=$O(^DIST(.403,DDSFNUM)) Q:'DDSFNUM  D
	. Q:$D(^DIST(.403,DDSFNUM,0))[0
	. S DDSFRM=DDSFNUM_U_$P(^DIST(.403,DDSFNUM,0),U),DDSDDP=+$P(^(0),U,8)
	. S DDSREFS=$$REF^DDS0(DDSFRM)
	. W:'$D(DDSQUIET) !?3,$P(DDSFRM,U,2),?35,"(#"_+DDSFRM_")"
	. D EN(DDSFRM,DDSDDP)
	. I $G(DIERR),'$D(DDSQUIET) W !,$C(7) D MSG^DIALOG("BW") W !
	Q
	;
EN(DDSFRM,DDSDDP,DDSREFS)	;Compile a form
	N DDSDO,DDSPG,DDSNDD,DDSPGRP
	;
	S:'$G(DDSDDP) DDSDDP=$P(^DIST(.403,+DDSFRM,0),U,8)
	S:$G(DDSREFS)="" DDSREFS=$$REF^DDS0(DDSFRM)
	K @DDSREFS
	;
	;Find page groups
	D PGRP^DDSZ3(+DDSFRM,.DDSPGRP)
	;
	S DDSPG=0,(DDSDO,DDSNDD)=1
	F  S DDSPG=$O(^DIST(.403,+DDSFRM,40,DDSPG)) Q:'DDSPG  D PG(DDSFRM,DDSPG,DDSDDP,.DDSDO,.DDSNDD) Q:$G(DIERR)
	I $G(DIERR) D ERR(DDSFRM,DDSREFS) Q
	S $P(^DIST(.403,+DDSFRM,0),U,9,11)=+$G(DDSDO)_U_+$G(DDSNDD)_U_1 ;DDSNDD=1 means don't need a starting DA
	Q
	;
PG(DDSFRM,DDSPG,DDSDDP,DDSDO,DDSNDD)	;Compile a page
	;
	Q:$D(^DIST(.403,+DDSFRM,40,DDSPG,0))[0
	D:$P($G(^DIST(.403,+DDSFRM,40,DDSPG,1)),U,2)]"" ASUB^DDSZ3(DDSPG,DDSFRM)
	;
	;Get page coordinates
	S DDSPX=$P(^DIST(.403,+DDSFRM,40,DDSPG,0),U,3)
	S DDSPY=$P(DDSPX,",")-1,DDSPX=$P(DDSPX,",",2)-1
	S:DDSPY<0 DDSPY=0 S:DDSPX<0 DDSPX=0
	;
	;Compile header block
	S DDSB=$P($G(^DIST(.403,+DDSFRM,40,DDSPG,0)),U,2)
	I DDSB]"" D BLK(DDSFRM,DDSPG,DDSDDP,DDSPY,DDSPX,DDSB,"",1,"",.DDSNDD,.DDSSCR,.DDSNAV,.DDSORD) G:$G(DIERR) END
	;
	;Compile all other blocks on page
	S DDSBO="" F  S DDSBO=$O(^DIST(.403,+DDSFRM,40,DDSPG,40,"AC",DDSBO)) Q:DDSBO=""  S DDSB=$O(^(DDSBO,0)) Q:'DDSB  D BLK(DDSFRM,DDSPG,DDSDDP,DDSPY,DDSPX,DDSB,DDSBO,"",.DDSDO,.DDSNDD,.DDSSCR,.DDSNAV,.DDSORD) G:$G(DIERR) END
	;
	D:$D(DDSSCR)!$D(DDSORD) EN^DDSZ2(.DDSSCR,.DDSNAV,.DDSORD,.DDSRNAV)
	;
END	K DDSB,DDSBO,DDSMUL,DDSNAV,DDSORD
	K DDSP,DDSPX,DDSPY,DDSREP,DDSRNAV,DDSSCR
	Q
	;
BLK(DDSFRM,DDSPG,DDSDDP,DDSPY,DDSPX,DDSB,DDSBO,DDSH,DDSDO,DDSNDD,DDSSCR,DDSNAV,DDSORD)	;
	;Compile block
	; DDSH   = 1 if header block
	; DDSDO  = killed if any edit blocks
	; DDSNDD = killed if any DD fields
	;
	N DDP
	I $D(^DIST(.404,DDSB,0))[0 D BLD^DIALOG(3051,"#"_DDSB) Q
	S DDSDN=$P(^DIST(.404,DDSB,0),U,3),DDP=+$P(^(0),U,2)
	;
	S DDSPTB=""
	S:'$G(DDSH) DDSPTB=$G(^DIST(.403,+DDSFRM,40,DDSPG,40,DDSB,1))
	;
	;Get DDSBY,DDSBX,DDSTP
	I $G(DDSH) S DDSBY=DDSPY,DDSBX=DDSPX,DDSTP="h",DDSREP=1
	E  D
	. S DDSBX=$P(^DIST(.403,+DDSFRM,40,DDSPG,40,DDSB,0),U,3),DDSTP=$P(^(0),U,4) S DDSREP=$S($G(^(2)):^(2),1:1)
	. K:DDSTP="e" DDSDO
	. S DDSBY=$P(DDSBX,",")-1,DDSBX=$P(DDSBX,",",2)-1
	. S:DDSBY<0 DDSBY=0 S:DDSBX<0 DDSBX=0
	. S DDSBY=DDSBY+DDSPY,DDSBX=DDSBX+DDSPX
IND	. I DDSREP>1,+$G(^DIST(.403,+DDSFRM,21))=+$P($G(^DIST(.403,+DDSFRM,40,DDSPG,0)),U) D  ;RECORD SELECTION PAGE USING REPEATING BLOCK
	..N IND
	..S IND=$P(^DIST(.403,+DDSFRM,40,DDSPG,40,DDSB,2),U,2) I IND]"",$D(^DD(+DDSDDP,0,"IX",IND,+DDSDDP)) D
	...S IND=^DIC(+DDSDDP,0,"GL")_""""_IND_"""" ;BUILD COMPUTED MULTIPLE OFF THE REPEATING-BLOCK INDEX
	...I $D(^DIST(.403,+DDSFRM,40,DDSPG,40,DDSB,"COMP MUL"))
	...S ^("COMP MUL")="N D,DIMQ,DIMSTRT,DIMSCNT S (DIMQ,DIMSTRT)=$NA("_IND_")),DIMSCNT=$QL(DIMQ) F  S DIMQ=$Q(@DIMQ) Q:DIMQ=""""  Q:$NA(@DIMQ,DIMSCNT)'=DIMSTRT  S D=$QS(DIMQ,$QL(DIMQ)) Q:'D  I @DIMQ="""" N D0 S D0=D X DICMX"
	..I $G(^DIST(.403,+DDSFRM,40,DDSPG,40,DDSB,"COMP MUL"))]"" S ^("COMP MUL PTR")=+DDSDDP
	;
	;Set @DDSREFS@(DDSPG,DDSB)
	S @DDSREFS@(DDSPG,DDSB)=DDSBY_U_DDSBX_U_$P($G(^DIST(.404,DDSB,0)),U,2)_U_DDSDN_U_DDSTP_$S(DDSREP>1:U_U_+DDSREP,1:"")
	;
	D:DDSPTB]"" PT^DDSPTR(DDSDDP,DDSPTB,DDSFRM,DDSPG,DDSB)
	D EN^DDSZ1(DDSPG,DDSB,DDP,DDSBY,DDSBX,DDSBO,DDSTP,DDSREP,.DDSNDD,.DDSPGRP,.DDSSCR,.DDSNAV,.DDSORD,.DDSRNAV)
	;
	K DDSBX,DDSBY,DDSDN,DDSPTB,DDSTP
	Q
	;
ENGRP(DDSFRM)	;Compile a form and all forms that use any of the blocks
	;on that form
	N DDSLST
	D FRMLST(DDSFRM,.DDSLST)
	;
	;Compile all forms in DDSLST
	S DDSFRM=0 F  S DDSFRM=$O(DDSLST(DDSFRM)) Q:'DDSFRM  D EN(DDSFRM)
	Q
	;
DELGRP(DDSFRM)	;Uncompile a form and all forms that use any of the blocks
	;on that form
	N DDSLST
	D FRMLST(DDSFRM,.DDSLST)
	;
	;Uncompile all forms in DDSLST
	S DDSFRM=0 F  S DDSFRM=$O(DDSLST(DDSFRM)) Q:'DDSFRM  D DEL(DDSFRM)
	Q
	;
ENLIST(DDSROOT)	;Compile all forms in @DDSROOT
	N DDSFRM
	S DDSFRM=0 F  S DDSFRM=$O(@DDSROOT@(DDSFRM)) Q:'DDSFRM  D EN(DDSFRM)
	Q
	;
FRMLST(DDSFRM,DDSLST)	;Build list of forms that contain blocks on this form
	N DDSPG,DDSBK
	S DDSPG=0 F  S DDSPG=$O(^DIST(.403,DDSFRM,40,DDSPG)) Q:'DDSPG  D
	. D BLDLST($P($G(^DIST(.403,DDSFRM,40,DDSPG,0)),U,2),.DDSLST)
	. S DDSBK=0 F  S DDSBK=$O(^DIST(.403,DDSFRM,40,DDSPG,40,DDSBK)) Q:'DDSBK  D
	.. D BLDLST($P($G(^DIST(.403,DDSFRM,40,DDSPG,40,DDSBK,0)),U),.DDSLST)
	Q
	;
BLDLST(DDSBK,DDSLST)	;Build list of forms that contain a given block
	N DDSFRM
	Q:'$G(DDSBK)
	S DDSFRM=0 F  S DDSFRM=$O(^DIST(.403,"AB",DDSBK,DDSFRM)) Q:'DDSFRM  S DDSLST(DDSFRM)=""
	S DDSFRM=0 F  S DDSFRM=$O(^DIST(.403,"AC",DDSBK,DDSFRM)) Q:'DDSFRM  S DDSLST(DDSFRM)=""
	Q
	;
DELALL	;Delete compile global for all forms
	N DDSFRM,DDSFNUM,DDSREFS
	W:'$D(DDSQUIET) !,"Deleting compiled form data ...",!
	;
	S DDSFNUM=0
	F  S DDSFNUM=$O(^DIST(.403,DDSFNUM)) Q:'DDSFNUM  D
	. Q:$D(^DIST(.403,DDSFNUM,0))[0
	. S DDSFRM=DDSFNUM_U_$P(^DIST(.403,DDSFNUM,0),U)
	. W:'$D(DDSQUIET) !?3,$P(DDSFRM,U,2),?35,"(#"_+DDSFRM_")"
	. D DEL(DDSFRM)
	Q
	;
DEL(DDSFRM)	;Delete compiled global
	N DDSREFS
	S DDSREFS=$$REF^DDS0(DDSFRM) K @DDSREFS
	S $P(^DIST(.403,+DDSFRM,0),U,11)=""
	Q
	;
ERR(DDSFRM,DDSREFS)	;Print error, kill compiled global
	Q:'$G(DIERR)
	N DDSNAM
	S DDSNAM=$P(DDSFRM,U,2)
	S:DDSNAM="" DDSNAM=$P($G(^DIST(.403,+DDSFRM,0)),U)
	D BLD^DIALOG(3002,DDSNAM)
	S $P(^DIST(.403,+DDSFRM,0),U,11)=""
	K @DDSREFS
	Q
