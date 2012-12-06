DIFGGSB1	;SFISC/XAK,EDE(OHPRD)-FILEGRAM SPECIAL BLOCK PART 2 ;8/12/98  13:16
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
BODY	S DIFGSB(DILL,"SPSPEC")=0
	I $D(DIFG(DILL,"FUNC")),"AL"[DIFG(DILL,"FUNC") I 1
	E  I $D(DIFG(DILL,"NOKEY"))
	E  D SPSPEC^DIFGGSB2
	Q:DIFGSB(DILL,"SPSPEC")
	D P01
	D SPEC
	D IDENT
	Q
	;
P01	; .01 FIELD WHEN IT IS A POINTER
	Q:$P(^DD(DIFG(DILL,"FILE"),.01,0),U,2)'["P"
	S DIFGSB(DILL,"FLD")=.01
	D SETXY
	Q:Y=""
	D PTRCHK^DIFGGSB2
	Q
	;
SPEC	; SPECIFIERS
	S DIFGSB(DILL,"SBT")="SPECIFIER:",%=""
	F DIFGSB(DILL,"FLD")=0:0 D SPEC2 Q:DIFGSB(DILL,"FLD")'=+DIFGSB(DILL,"FLD")  S %=%_$S(%="":DIFGSB(DILL,"FLD"),1:";"_DIFGSB(DILL,"FLD"))
	I '$D(DIFG(DILL,"MUL")) S DR=% D:%'="" FIELDS I 1
	E  S DR(DIFG(DILL,"FILE"))=% D:%'="" FIELDS
	K ^UTILITY("DIQ1",$J,DIFG(DILL,"FILE"))
	I '$D(DIFG(DILL,"MUL")) K DA,DIC,DR
	K % Q
	;
SPEC2	S DIFGSB(DILL,"FLD")=$O(^DD(DIFG(DILL,"FILE"),0,"SP",DIFGSB(DILL,"FLD")))
	Q
	;
IDENT	; IDENTIFIERS
	S DIFGSB(DILL,"SBT")="IDENTIFIER:",%=""
	N DIXIEN,DIKEY S DIXIEN=0,DIKEY=";"
	I $G(DIAR)=4 S DIXIEN=$O(^DD("KEY","AP",DIFG(DILL,"FILE"),"P",0))
	F DIFGSB(DILL,"FLD")=0:0 D IDENT2 Q:DIFGSB(DILL,"FLD")'=+DIFGSB(DILL,"FLD")  D:'$D(^DD(DIFG(DILL,"FILE"),0,"SP",DIFGSB(DILL,"FLD"))) IDENT3
	I '$D(DIFG(DILL,"MUL")) S DR=% D:%'="" FIELDS I 1
	E  S DR(DIFG(DILL,"FILE"))=% D:%'="" FIELDS
	K ^UTILITY("DIQ1",$J,DIFG(DILL,"FILE"))
	I '$D(DIFG(DILL,"MUL")) K DA,DIC,DR
	K %
	Q
	;
IDENT2	N DIOUT S DIOUT=0
	I DIXIEN F  D  Q:DIOUT!('DIFGSB(DILL,"FLD"))
	. S DIFGSB(DILL,"FLD")=$O(^DD("KEY",DIXIEN,2,"BB",DIFGSB(DILL,"FLD")))
	. Q:'DIFGSB(DILL,"FLD")!(DIFGSB(DILL,"FLD")=.01)
	. Q:$O(^DD("KEY",DIXIEN,2,"BB",DIFGSB(DILL,"FLD"),0))'=DIFG(DILL,"FILE")
	. Q:'$D(^DD(DIFG(DILL,"FILE"),DIFGSB(DILL,"FLD"),0))
	. S DIOUT=1,DIKEY=DIKEY_DIFGSB(DILL,"FLD")_";" Q
	Q:DIOUT  S DIXIEN=0
	F  S DIFGSB(DILL,"FLD")=$O(^DD(DIFG(DILL,"FILE"),0,"ID",DIFGSB(DILL,"FLD"))) Q:'DIFGSB(DILL,"FLD")  Q:DIKEY'[(";"_DIFGSB(DILL,"FLD"))
	Q
	;
IDENT3	S %=%_$S(%="":DIFGSB(DILL,"FLD"),1:";"_DIFGSB(DILL,"FLD"))
	Q
	;
FIELDS	I $D(DIFGGU(DIFG(DILL,"FILE"),DIFG(DILL,"FE"))) D DRFIX
	I '$D(DIFG(DILL,"MUL")) Q:DR=""
	E  Q:DR(DIFG(DILL,"FILE"))=""
	K ^UTILITY("DIQ1",$J,DIFG(DILL,"FILE"))
	S:'$D(DIFG(DILL,"MUL")) DIC=DIFG(DILL,"FILE"),DA=DIFG(DILL,"FE")
	S DIQ(0)="N" D EN^DIQ1 K DIQ
	F DIFGSB(DILL,"FLD")=0:0 D FIELDS2 Q:DIFGSB(DILL,"FLD")'=+DIFGSB(DILL,"FLD")  S X=^(DIFGSB(DILL,"FLD")) D FIELDS3
	Q
	;
DRFIX	; ADJUST DR FOR MODIFIED/DELETED VALUES
	NEW T
	I '$D(DIFG(DILL,"MUL")) S T=DR
	E  S T=DR(DIFG(DILL,"FILE"))
	F %=1:1 S X=$P(T,";",%) Q:X=""  S %(X)="" I $D(DIFGGU(DIFG(DILL,"FILE"),DIFG(DILL,"FE"),X)) K %(X) S DIFGSB(DILL,"FLD")=X,X=DIFGGU(DIFG(DILL,"FILE"),DIFG(DILL,"FE"),X) D DRFIX2
	S (T,X)=""
	F %=0:0 S X=$O(%(X)) Q:X=""  S T=T_$S(T="":"",1:";")_X
	I '$D(DIFG(DILL,"MUL")) S DR=T
	E  S DR(DIFG(DILL,"FILE"))=T
	Q
	;
DRFIX2	NEW %,DR,T
	D FIELDS3
	Q
	;
FIELDS2	S DIFGSB(DILL,"FLD")=$O(^UTILITY("DIQ1",$J,DIFG(DILL,"FILE"),DIFG(DILL,"FE"),DIFGSB(DILL,"FLD")))
	Q
	;
FIELDS3	Q:X=""
	D SETXY
	K F,N,P,W
	S V=DIFGSB(DILL,"SBT")_$P(^DD(DIFG(DILL,"FILE"),DIFGSB(DILL,"FLD"),0),U,1)_U_$S(DIFG("PARM")["N":DIFGSB(DILL,"FLD"),1:"")
	S:DIFGSB(DILL,"SBT")["KEY" V=V_U_$P(DIFGSB(DILL,"SPSPEC"),U,2)
	S V=V_"="_X
	D INCSET^DIFGGU
	D:Y'="" PTRCHK^DIFGGSB2
	K X,Y
	Q
SETXY	; If previously looked up pointer set @LINK
	S Y=""
	Q:$P(^DD(DIFG(DILL,"FILE"),DIFGSB(DILL,"FLD"),0),U,2)'["P"
	S F=+$P($P(^DD(DIFG(DILL,"FILE"),DIFGSB(DILL,"FLD"),0),U,2),"P",2),W=$P(^(0),U,4),N=$P(W,";",1),P=$P(W,";",2)
	I $D(DIFGGU(DIFG(DILL,"FILE"),DIFG(DILL,"FE"),DIFGSB(DILL,"FLD"),"P")) S Y=DIFGGU(DIFG(DILL,"FILE"),DIFG(DILL,"FE"),DIFGSB(DILL,"FLD"),"P") I 1
	E  S Y=$P(@(DIFG(DILL,"FGBL")_DIFG(DILL,"FE")_",N)"),U,P)
	I $D(^UTILITY("DIFGLINK",$J,F,Y)) S X="@"_^UTILITY("DIFGLINK",$J,F,Y),Y="" Q
	S ^UTILITY("DIFGLINK",$J)=$S($D(^UTILITY("DIFGLINK",$J))#2:^UTILITY("DIFGLINK",$J)+1,1:1)
	S ^UTILITY("DIFGLINK",$J,F,Y)=^UTILITY("DIFGLINK",$J)
	S Y="@"_^UTILITY("DIFGLINK",$J)
	Q
