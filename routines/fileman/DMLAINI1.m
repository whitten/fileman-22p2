DMLAINI1	; ; 20-NOV-2012
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	; LOADS AND INDEXES DD'S
	;
	K DIF,DIK,D,DDF,DDT,DTO,D0,DLAYGO,DIC,DIDUZ,DIR,DA,DFR,DTN,DIX,DZ D DT^DICRW S %=1,U="^",DSEC=1
	S NO=$P("I 0^I $D(@X)#2,X[U",U,%) I %<1 K DIFQ Q
ASK	I %=1,$D(DIFQ(0)) W !,"SHALL I WRITE OVER FILE SECURITY CODES" S %=2 D YN^DICN S DSEC=%=1 I %<1 K DIFQ Q
	Q:'$D(DIFQ)  S %=2 W !!,"ARE YOU SURE EVERYTHING'S OK" D YN^DICN I %-1 K DIFQ Q
	I $D(DIFKEP) F DIDIU=0:0 S DIDIU=$O(DIFKEP(DIDIU)) Q:DIDIU'>0  S DIU=DIDIU,DIU(0)=DIFKEP(DIDIU) D EN^DIU2
	D DT^DICRW K ^UTILITY(U,$J),^UTILITY("DIK",$J) D WAIT^DICD
	S DN="^DMLAI" F R=1:1:7 D @(DN_$$B36(R)) W "."
	F  S D=$O(^UTILITY(U,$J,"SBF","")) Q:D'>0  K:'DIFQ(D) ^(D) S D=$O(^(D,"")) I D>0  K ^(D) D IX
KEYSNIX	; Keys and new style indexes installer ; new in FM V22.2
	N DIFRSA S DIFRSA=$NA(^UTILITY("KX",$J)) ; Tran global for Keys and Indexes
	N DIFRFILE S DIFRFILE=0 ; Loop through files
	F  S DIFRFILE=$O(@DIFRSA@("IX",DIFRFILE)) Q:'DIFRFILE  D
	. K ^TMP("DIFROMS2",$J,"TRIG")
	. N DIFRD S DIFRD=0
	. F  S DIFRD=$O(@DIFRSA@("IX",DIFRFILE,DIFRD)) Q:'DIFRD  D DDIXIN^DIFROMSX(DIFRFILE,DIFRD,DIFRSA) ; install New Style Indexes
	. K ^TMP("DIFROMS2",$J,"TRIG")
	. S DIFRD=0
	. F  S DIFRD=$O(@DIFRSA@("KEY",DIFRFILE,DIFRD)) Q:'DIFRD  D DDKEYIN^DIFROMSY(DIFRFILE,DIFRD,DIFRSA) ; install keys
	K @DIFRSA ; kill off tran global
	; VEN/SMH v22.2: Below I added a K D1 because it leaks from the call causing the key matching algo to fail.
DATA	W "." S (D,DDF(1),DDT(0))=$O(^UTILITY(U,$J,0)) Q:D'>0
	I DIFQR(D) S DTO=0,DMRG=1,DTO(0)=^(D),Z=^(D)_"0)",D0=^(D,0),@Z=D0,DFR(1)="^UTILITY(U,$J,DDF(1),D0,",DKP=DIFQR(D)'=2 F D0=0:0 S D0=$O(^UTILITY(U,$J,DDF(1),D0)) S:D0="" D0=-1 K D1 Q:'$D(^(D0,0))  S Z=^(0) D I^DITR
	K ^UTILITY(U,$J,DDF(1)),DDF,DDT,DTO,DFR,DFN,DTN G DATA
	;
W	S Y=$P($T(@X),";",2) W !,"NOTE: This package also contains "_Y_"S",! Q:'$D(DIFQ(0))
	S %=1 W ?6,"SHALL I WRITE OVER EXISTING "_Y_"S OF THE SAME NAME" D YN^DICN I '% W !?6,"Answer YES to replace the current "_Y_"S with the incoming ones." G W
	S:%=2 DIFQ(X)=0 K:%<0 DIFQ
	Q
	;
OPT	;OPTION
RTN	;ROUTINE DOCUMENTATION NOTE
FUN	;FUNCTION
BUL	;BULLETIN
KEY	;SECURITY KEY
HEL	;HELP FRAME
DIP	;PRINT TEMPLATE
DIE	;INPUT TEMPLATE
DIB	;SORT TEMPLATE
DIS	;FORM
REM	;REMOTE PROCEDURE
	;
SBF	;FILE AND SUB FILE NUMBERS
IX	W "." S DIK="A" F %=0:0 S DIK=$O(^DD(D,DIK)) Q:DIK=""  K ^(DIK)
	S DA(1)=D,DIK="^DD("_D_"," D IXALL^DIK
	I $D(^DIC(D,"%",0)) S DIK="^DIC(D,""%""," G IXALL^DIK
	Q
B36(X)	Q $$N(X\(36*36)#36+1)_$$N(X\36#36+1)_$$N(X#36+1)
N(%)	Q $E("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",%)
