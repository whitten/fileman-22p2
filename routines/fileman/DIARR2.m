DIARR2	;SFISC/DCM-ARCHIVING(READ ARCHIVED FG) PROCESS REQUEST ;11/18/92  11:29 AM
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
	I $D(DIARIDX) D PROC^DIARR6 G C
	;
FG	F DIARZ=1:1 X DIARX Q:(DIARL="#$#")  S ^TMP("DIARFG",$J,DIARZ)=DIARL D:DIARL="$END DAT" FG1
C	S X=DIARIO X ^DD("FUNC",7,1) K:$D(DIARIO)#2&(DIARIO]"") IO(1,DIARIO)
	D EOP
	Q
	;
FG1	F DIARZ=1:1 S DIARFGL=$G(^TMP("DIARFG",$J,DIARZ)) Q:((DIARFGL="$END DAT")!(DIARFGEN))  D FG2
	D IDS
	D MATCH
	D EOP
	Q
	;
FG2	Q:$P(DIARFGL,U)="$DAT"
	I DIARNM,$P(DIARFGL,U)=DIARFILE S DIARA(".01")=$P(DIARFGL,"=",2) Q
	I $P(DIARFGL,":")="BEGIN" D FG3 Q
	I $P(DIARFGL,":")="IDENTIFIER" S DIARA("ID",+$P(DIARFGL,U,2))=$P(DIARFGL,"=",2) Q
	I $P(DIARFGL,":")="SPECIFIER" S DIARA("ID",+$P(DIARFGL,U,2))=$P(DIARFGL,"=",2) Q
	I +$P(DIARFGL,U,2)=".01" S DIARA(".01")=$P(DIARFGL,"=",2) S DIARFGEN=1 Q
	Q
	;
FG3	Q:+$P(DIARFGL,U,2)=DIARFN
	S DIARF2=+$P(DIARFGL,U,2),DIARZ=DIARZ+1
	F DIARZ=DIARZ:1 S DIARFGL=$G(^TMP("DIARFG",$J,DIARZ)) Q:(($P(DIARFGL,":")="END")&(+$P(DIARFGL,U,2)=DIARF2))
	Q
	;
IDS	F DIARIDS=0:0 S DIARIDS=$O(DIARID(DIARIDS)) Q:DIARIDS'>0  I '$D(DIARA("ID",DIARIDS)) S DIARA("ID",DIARIDS)=""
	Q
	;
MS	S DIARMTID="",DIARMT01=0,DIARMTCH=0,DIARIDDN=0,DIARRF(DIARY)=$S($D(DIARRF(DIARY)):DIARRF(DIARY),1:0) Q
	;
MATCH	F DIARY=0:0 S DIARY=$O(DIARR(DIARY)) Q:DIARY'>0  D MS D:$D(DIARR(DIARY,".01")) MATCH01 D:$D(DIARR(DIARY,"ID")) MATCHID:'DIARIDDN D:DIARMTCH FOUND
	Q
	;
MATCH01	Q:DIARR(DIARY,".01")=""  Q:DIARA(".01")=""
	I $P(DIARA(".01"),DIARR(DIARY,.01))="" S DIARMT01=1
	I $D(DIARR(DIARY,"ID")) D MATCHID I 'DIARMTID Q
	I DIARMT01 S DIARMTCH=1
	Q
	;
MATCHID	F DIARZID=0:0 S DIARZID=$O(DIARR(DIARY,"ID",DIARZID))  Q:DIARZID'>0  D MATCHID1 Q:DIARMTID=0
	I DIARMTID,'$D(DIARR(DIARY,".01")) S DIARMTCH=1
	S DIARIDDN=1
	Q
	;
MATCHID1	Q:DIARR(DIARY,"ID",DIARZID)=""  Q:DIARA("ID",DIARZID)=""
	I $P(DIARA("ID",DIARZID),DIARR(DIARY,"ID",DIARZID))="" S DIARMTID=1 Q
	S DIARMTID=0
	Q
	;
FOUND	S DIARFND=1
	I $D(DIARIDX) S DIARIXX(DIARIXCT)=DIARIXX(DIARIXCT)_DIARY_"," Q
	S %X="^TMP(""DIARFG"",$J,",%Y="^TMP(""DIAR"",$J,DIARY,DIARRF(DIARY)+1," D %XY^%RCR
	S DIARRF(DIARY)=DIARRF(DIARY)+1
	Q
	;
EOP	S DIARZ=0,DIARFGEN=0
	K ^TMP("DIARFG",$J),DIARA
	Q
