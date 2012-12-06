DIFGG4	;SFISC/XAK,EDE(OHPRD)-FILEGRAM SUBFILES ;6/10/93  1:41 PM
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
SUBFILE	; DO ONE SUBFILE
	F DIFG(DILL,"FE")=0:0 S DIFG(DILL,"FE")=$O(@(DIFG(DILL,"FGBL")_DIFG(DILL,"FE")_")")) Q:DIFG(DILL,"FE")'=+DIFG(DILL,"FE")  D SUBENTRY
	Q
	;
SUBENTRY	; DO ONE SUBFILE ENTRY
	D DIS Q:'$T
	D DR S DR(DIFG(DILL,"FILE"))=.01
	S DIFG(DILL,"MUL")=1
	D LOOKUP^DIFGGU
	I $D(DIFGGUQ) K DIFGGUQ,DIFG(DILL,"MUL") Q
	D DR,DRS
	D RECURSEM
	S V="^" D INCSET^DIFGGU
	K DIFG(DILL,"MUL"),DA,DR
	Q
	;
DR	; CREATE DR-STRINGS
	K DR S I=0
	F %=DIFG(DILL,"FILE"):0 Q:'$D(^DD(%,0,"UP"))  S X=^("UP"),Y=$O(^DD(X,"SB",%,0)),DR(X)=Y,DA(%)=DIFG(DILL-I,"FE"),%=X,I=I+1
	S DA=DIFG(DILL-I,"FE"),DIC=DIFG(DILL-I,"FILE"),DR=DR(%) K DR(%)
	Q
	;
DRS	; PROCESS ALL DR STRINGS FOR FILE
	S DR(DIFG(DILL,"FILE"))="",DITAB=DITAB+2
	I $P(^DIPT(DIFGT,1,DIFGI,0),U,8) F DIFG2=.001:0 S %=DIFG(DILL,"FILE"),DIFG2=$O(^DD(%,DIFG2)) Q:DIFG2'>0  D DRA
	F DIFG2=0:0 S DIFG2=$O(^DIPT(DIFGT,1,DIFGI,"F",DIFG2)) Q:DIFG2'=+DIFG2  I $D(^(DIFG2,0)) S DR(DIFG(DILL,"FILE"))=DR(DIFG(DILL,"FILE"))_^(0)_";" I $L(DR(DIFG(DILL,"FILE")))>200 D EN^DIFGG2 S DR(DIFG(DILL,"FILE"))=""
	D EN^DIFGG2:DR(DIFG(DILL,"FILE"))]""
	S DITAB=DITAB-2
	Q
	;
DRA	;Process all subfields
	S %1=$P(^(0),U,0) I $S('%1:%1'["C",1:$P(^DD(+%1,.01,0),U,2)["W") S DR(%)=DR(%)_DIFG2_";" I $L(DR(%))>200 D EN^DIFGG2 S %=DIFG(DILL,"FILE"),DR(%)=""
	Q
	;
DIS	; SCREEN THIS ENTRY
	F %=1:1:DILL S @("D"_(%-1))=DIFG(%,"FE")
	I $D(DIFG(DIFG(DILL,"FILE"),"S"))#2 X DIFG(DIFG(DILL,"FILE"),"S") Q
	I 1 Q
	;
RECURSEM	; RECURSION FOR DEEPER SUBFILE SHIFTS
	S DITAB=DITAB+2
	D NEXTLVL^DIFGG
	S DITAB=DITAB-2
	Q
	;
	;
DIFGG3	; FILEGRAM NAVIGATION
	; SEE DIFGG3^DIFGGDOC
	;
FILE	; PROCESS ONE FILE
	F DIFG(DILL,"FE")=0:0 D FILE2 Q:DIFG(DILL,"FE")=""  D ENTRY
	K I,S,V,X
	Q
	;
FILE2	;
	S X=$O(^DD(DIFG(DILL,"FILE"),0,"IX",DIFG(DILL,"XREF"),0))
	Q:'X
	S Y=$O(^DD(DIFG(DILL,"FILE"),0,"IX",DIFG(DILL,"XREF"),X,0))
	Q:'Y
	I $P(^DD(X,Y,0),U,2)["V" S DIFG(DILL,"FSV")=""""_DIFG(DILL-1,"FE")_";"_$P(^DIC(DIFG(DILL-1,"FILE"),0,"GL"),U,2)_"""" I 1
	E  S DIFG(DILL,"FSV")=DIFG(DILL-1,"FE")
	S DIFG(DILL,"FE")=$O(@(DIFG(DILL,"FGBL")_""""_DIFG(DILL,"XREF")_""","_DIFG(DILL,"FSV")_","_DIFG(DILL,"FE")_")"))
	Q
	;
ENTRY	; PROCESS ONE FILE ENTRY
	S DIFG(DILL,"NAV")=1
	D LOOKUP^DIFGGU
	K DIFG(DILL,"NAV")
	I $D(DIFGGUQ) K DIFGGUQ Q
	S DITAB=DITAB+2
	D ^DIFGG2
	D RECURSEF
	S DITAB=2*(DILL-1)
	S V=":" D INCSET^DIFGGU
	Q
	;
RECURSEF	; RECURSION FOR DEEPER FILE SHIFTS
	D NEXTLVL^DIFGG
	Q
