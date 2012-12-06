DIQGDD	;SFISC/DCL-DATA DICTIONARY ATTRIBUTE RETRIEVER ;10:55 AM  8 Nov 2000
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
GET(DIQGR,DA,DR,DIQGPARM,DIQGETA,DIQGERRA,DIQGIPAR)	;
EN3	I $G(U)'="^" N U S U="^"
	I $G(DIQGIPAR)'["A" K DIERR,^TMP("DIERR",$J)
	I $G(DIQGR)'>0 N X S X(1)="FILE" Q $$F^DIQG(.X,1)
	I $G(DA)']"" S DA=DIQGR,DIQGR=1 I '$D(^DIC(DA,0)) S X(1)="FILE" Q $$F^DIQG(.X,1)
	S:DIQGR>1 DIQGPARM=$G(DIQGPARM)_"D"
	I DA'?.N,$D(^DD(DIQGR,"B",DA)) S DA=$O(^(DA,"")) I $O(^(DA)) D 200 Q ""
	I DA'>0 D 200 Q ""
	I DR="FIELD LENGTH" Q $$FL^DIQGDDU(DIQGR,DA)
	I DR="REQUIRED IDENTIFIERS" G RI^DIQGDDU
	N DRSV S DRSV=DR N DR
	S DR=$$ATRBT(DIQGR=1,$G(DRSV)) I 'DR D 202("ATTRIBUTE") Q ""
	G DDENTRY^DIQG
	;
FIELD(DIQGR,DA,DR,DIQGPARM,DIQGTA,DIQGERRA,DIQGIPAR)	;
EN1	N DIQGERR,DIQGEY,DIQGSAL,DIQGFNUL,DIQGSALX,DIQGTAXX
	S DIQGEY(1)=$G(DIQGR)
	I $G(U)'="^" N U S U="^"
	I $G(DIQGIPAR)'["A" K DIERR,^TMP("DIERR",$J)
	I $G(DIQGR)'>0 D 202("FILE") Q
	I $G(DA)']"" D 202("FIELD") Q
	I $D(^DD(DIQGR,0))[0 D 202("FILE") Q
	I $G(DIQGTA)']"" D 202("TARGET ARRAY") Q
	S DIQGPARM=$G(DIQGPARM)_"D",DIQGFNUL=DIQGPARM["N"
	I DA'?.N,$D(^DD(DIQGR,"B",DA)) S DA=$O(^(DA,"")) I $O(^(DA)) N X S X(1)=DA,X("FILE")=DIQGR D BLD^DIALOG(505,.X),FE Q
	I DA'>0 S DIQGEY(3)=DA D 200 Q
	I $D(^DD(DIQGR,DA,0))[0 S DIQGEY(3)=DA D 200 Q
	D BLDSAL(0,.DR,.DIQGSAL)
	I '$D(DIQGSAL),'$D(DIERR) D 200 Q
	I '$D(DIQGSAL) Q
	S DIQGSAL="" F  S DIQGSAL=$O(DIQGSAL(DIQGSAL)) Q:DIQGSAL=""  D
	.S DIQGTAXX=$S('$D(DIQGSAL(DIQGSAL,"#(word-processing)")):DIQGTA,1:$$OREF(DIQGTA)_$$Q(DIQGSAL)_")")
	.I DIQGSAL="FIELD LENGTH" S DIQGSALX=$$FL^DIQGDDU(DIQGR,DA) G SET
	.S DIQGSALX=$$GET^DIQG("^DD("_DIQGR_",",DA,DIQGSAL(DIQGSAL),DIQGPARM,DIQGTAXX,"","1A")
SET	.I DIQGSALX]"" S @DIQGTA@(DIQGSAL)=DIQGSALX Q
	.Q:DIQGFNUL
	.S @DIQGTA@(DIQGSAL)=DIQGSALX
	.Q
	Q
	;
BLDSAL(DIQGTYPE,DIQGDR,DIQGVALA)	;DIQGTYPE=1 for FILE and 0 for FIELD, DIQGDR=string/array, DIQGVALA=valid attribute list array
	; * If DIQGDR is an array pass by reference *
	I $G(DIQGDR)="*" D LIST^DIQGDDT($S(DIQGTYPE=1:"FILETXT",1:"FIELDTXT"),.DIQGVALA,"",3) Q
	N DIQGER,DIQGI,DIQGX,DIQGY D LIST^DIQGDDT($S(DIQGTYPE=1:"FILETXT",1:"FIELDTXT"),.DIQGX,"",3)
	I $G(DIQGDR)]"" F DIQGI=1:1 S DIQGY=$P(DIQGDR,";",DIQGI) Q:DIQGY=""  D
	.I '$D(DIQGX(DIQGY)) S DIQGER(4)=DIQGY D 200 Q
	.S DIQGVALA(DIQGY)=DIQGX(DIQGY) S:$D(DIQGX(DIQGY,"#(word-processing)")) DIQGVALA(DIQGY,"#(word-processing)")=DIQGX(DIQGY)
	Q:$D(DIQGVALA)
	S DIQGY="" F  S DIQGY=$O(DIQGDR(DIQGY)) Q:DIQGY=""  D
	.I '$D(DIQGX(DIQGY)) S DIQGER(4)=DIQGY D 200 Q
	.S DIQGVALA(DIQGY)=DIQGX(DIQGY) S:$D(DIQGX(DIQGY,"#(word-processing)")) DIQGVALA(DIQGY,"#(word-processing)")=DIQGX(DIQGY)
	.Q
	Q
	;
XDR(DIQGR,DR,DIQGERR)	;DIQGR DD FILE NUMBER EITHER 1 OR 0
	;DR IS DR STRING TO CONVERT TO NUMERIC DR STRING
	S DIQGR=+$G(DIQGR),DR=$G(DR)
	N I,X,XDR D LIST^DIQGDDT($S(DIQGR=1:"FILETXT",1:"FIELDTXT"),.X,4,3)
	I $G(DR)]"" S (X,XDR)="" F I=1:1 S X=$P(DR,";",I) Q:X=""  D
	.I '$D(X(X)) S DIQGERR(X)="" Q
	.S XDR=XDR_X(X)_";" Q
	I $D(DR)>1 S (X,XDR)="" F  S X=$O(DR(X)) Q:X=""  D:'$D(X(X))  S:X]"" XDR=XDR_X(X)_";"
	.I '$D(X(X)) S DIQGERR(X)="" Q
	.S XDR=XDR_X(X)_";" Q
	Q XDR
	;
ATRBT(TYPE,ATRIB)	;EXTRINSIC FUNCTION $$TEST IF VALID ATTRIBUTE
	;TYPE 0 OR 1 - FIELD=0, FILE=1 (^DD(0) OR ^DD(1))
	;ATRIB=ATTRIBUTE BEING REQUESTED
	Q:ATRIB']"" 0
	N X D LIST^DIQGDDT($S(TYPE=1:"FILETXT",1:"FIELDTXT"),.X,,3)
	Q $G(X(ATRIB))
DR(TYPE)	;TYPE=1,FILE OR 0,FIELD AND RETURNS DR STRING FOR ALL ATTRIBUTES IN INTERNAL FORM (ATTRIBUTE FIELD NUMBERS 3RD ;-PIECE
	S TYPE=+$G(TYPE)
	N X,Y
	D LIST^DIQGDDT($S(TYPE=1:"FILETXT",1:"FIELDTXT"),.X,3)
	S (X,Y)=.01 F  S Y=$O(X(Y)) Q:Y'>0  S X=X_";"_Y
	Q X
	;
FILELST(DIDARRAY)	;PASS TARGET ARRAY BY REFERENCE * * LIST FILE ATTRIBUTES * *
EN4	N EQL,TP,TYPE,DIQGDFLG
	S TYPE="FILETXT",DIQGDFLG="L"
	G ENLST^DIQGDDT
	;
FIELDLST(DIDARRAY)	;PASS TARGET ARRAY BY REFERENCE * * LIST FIELD ATTRIBUTES * *
EN5	N EQL,TP,TYPE,DIQGDFLG
	S TYPE="FIELDTXT",DIQGDFLG="L"
	G ENLST^DIQGDDT
	;
OREF(X)	N X1,X2 S X1=$P(X,"(")_"(",X2=$$OR2($P(X,"(",2)) Q:X2="" X1 Q X1_X2_","
OR2(%)	Q:%=")"!(%=",") "" Q:$L(%)=1 %  S:"),"[$E(%,$L(%)) %=$E(%,1,$L(%)-1) Q %
Q(%Z)	S %Z(%Z)="",%Z=$Q(%Z("")) Q $E(%Z,4,$L(%Z)-1)
200	D BLD^DIALOG(200),FE Q
202(E)	N X S X(1)=E
	D BLD^DIALOG(202,.X),FE
	Q
FE	I $G(DIQGERRA)]"" D CALLOUT^DIEFU(DIQGERRA)
	Q
