DDSRUN	;SFISC/MKO-RUN A FORM ;8DEC2003
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;
	;Select file (DDSFILE)
EGP	S DDS1=8108.3 D W^DICRW K DDS1 G:Y<0 RUNQ ;**CCO/NI 'RUN FORM:'
	G:'$D(@(DIC_"0)")) RUNQ
	K DDSFILE S DDSFILE=+Y
	;
	;Select form (DDSRUNDR)
	K DIC
	S DIC=.403,DIC(0)="QEA",D="F"_+Y
	S DIC("S")="I $P(^(0),U,8)=+DDSFILE"
	I DUZ(0)'="@" S DIC("S")=DIC("S")_" N DDSI F DDSI=1:1:$L($P(^(0),U,2)) I DUZ(0)[$E($P(^(0),U,2),DDSI) Q"
	W ! D IX^DIC K DIC,D G:Y<0 RUNQ
	S DDSRUNDR=+Y
	;
	I '$$COMPILED^DDS0(DDSRUNDR) D EN^DDSZ(DDSRUNDR) G:$G(DIERR) RUNQ
	;
	;Select page (DDSPAGE)
PAGE	K DIR S Y=$O(^DIST(.403,DDSRUNDR,40,0)) I '$O(^(Y)) S DDSPAGE=1 G REC ;DON'T ASK IF ONLY ONE!
	S Y=$G(^DIST(.403,DDSRUNDR,21)) I Y S DDSPAGE=+Y G REC ;IF THERE'S A RECORD SELECTION PAGE, USE IT
	S DIR(0)="NOA^1:999.9:1"
	S DIR("A")="Enter number of first page: ",DIR("B")=1
	W ! D ^DIR K DIR G:$D(DIRUT) RUNQ
	K DDSPAGE S:Y'=1 DDSPAGE=Y
	;
REC	;Select record (DA)
	K DA
	I '$P(^DIST(.403,DDSRUNDR,0),U,10),$S($G(DDSPAGE):$G(^(21))-DDSPAGE,1:1) D  G:DA<0 RUNQ ;IF IT'S A RECORD SELECTION PAGE, THAT WILL FIND 'DA'
	. S DIC=DDSFILE,DIC(0)="QEALM"
	. W ! D ^DIC K DIC
	. S DA=+Y
	K D,DIC,X,Y
	;
	;Invoke form
	K DR S DR=DDSRUNDR D ^DDS G:$D(DA) REC
	;
RUNQ	;Clean up and quit
	I $D(DIERR) W !,$C(7) D MSG^DIALOG("BW")
	K D,DIC,X,Y
	K DDSFILE,DDSPAGE,DDSRUNDR,DA,DR
	K DIRUT,DTOUT,DUOUT
	Q
