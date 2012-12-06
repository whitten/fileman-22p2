DIFG0	;SFISC/DG(OHPRD)-SETS UP DIC("S"), EVALS 1ST LINE OF A (SUB)FILE ; [ 05/25/93  10:17 AM ]
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
NDPC	;DETERMINE NODE,PIECE FOR DATA FOR THIS FIELD
	S DIFGCT=DIFGCT+1
	S:DIFG("PARAM")["N" DIFGNUMF(DIFGCT)=+$P(DIFGDIX,"^",2),DIFGPC(DIFGCT)=$P(^DD(DIC,DIFGNUMF(DIFGCT),0),"^",4)
	I '$D(DIFGPC(DIFGCT)) S DIFGNUMF(DIFGCT)=$O(^DD(DIC,"B",$P($P(DIFGDIX,"^"),":",2),"")),DIFGPC(DIFGCT)=$P(^DD(DIC,DIFGNUMF(DIFGCT),0),"^",4)
	S DIFGHAT=$P(^DD(DIC,DIFGNUMF(DIFGCT),0),U,2) I DIFGHAT["P",$P(DIFGDIX,"=",2)'?1"@"1N.N.1"E" S DIFGPTER(DIFGCT)=""
	D DICS
	D GETVAL
	Q
	;
DICS	;SET DIC("S")
	I $P(DIFGPC(DIFGCT),";",2)'["," S DIFGDOL="$P(^($P(DIFGPC("_DIFGCT_"),"";"")),U,$P(DIFGPC("_DIFGCT_"),"";"",2))="
	E  S DIFGDOL="$E(^($P(DIFGPC("_DIFGCT_"),"";"")),$P(DIFGPC("_DIFGCT_"),"";"",2))="
	I '$D(DIFGDIC(DIC)) S DIFGDICS(DIC)=1
	E  S DIFGDICS(DIC)=DIFGDICS(DIC)+1
	S DIFGDIC(DIC,DIFGDICS(DIC))="I "_DIFGDOL_$S($D(DIFGPTER(DIFGCT)):"",1:"DIFGVAL("_DIFGCT_")")
	Q
	;
GETVAL	;GETS VALUE TO RIGHT OF EQUAL SIGN
	I $P(DIFGDIX,"=",2)'?1"@"1N.N.1"E" S (DIFGVAL(DIFGCT),^UTILITY("DIFGX",$J,DIFGCT))=$P(DIFGDIX,"=",2) D:DIFGHAT["S" SETCODES D:DIFGHAT["D" DATE I 1
	E  S DIFGVAL(DIFGCT)=^UTILITY("DIFG@",$J,$P(DIFGDIX,"=",2)) S:$D(^UTILITY("DIFGX",$J,$P(DIFGDIX,"=",2))) ^UTILITY("DIFGX",$J,DIFGCT)=^($P(DIFGDIX,"=",2))
X1	Q
	;
SETCODES	;DETERMINE INTERNAL VALUE IF FIELD ATTRIBUTE IS SET OF CODES
	I $P(^DD(DIC,DIFGNUMF(DIFGCT),0),U,3)[":"_DIFGVAL(DIFGCT)_";" S DIFGSET=$P(^DD(DIC,DIFGNUMF(DIFGCT),0),U,3),%=$P(DIFGSET,":"_DIFGVAL(DIFGCT)_";"),%A=$L(%,";"),DIFGVAL(DIFGCT)=$P(%,";",%A)
	K DIFGSET,%,%A
	Q
	;
DATE	;GET INTERNAL FORM OF DATE
	S DIFGSAVX=X,%DT="T",X=$P(DIFGDIX,"=",2) D ^%DT S DIFGVAL(DIFGCT)=Y,X=DIFGSAVX
	I Y=-1 S DIFGER=5_U_DIFGY D ERROR^DIFG
	Q
	;
BASE	;BASE FILE ENTRY LINE
	K DIFGXRF(DIFGMULT)
	I $P($P(DIFGDIX,U,3),"=",2)?1"@"1N.N1"E" S (DIFGALNK,Y)=^UTILITY("DIFG@",$J,$E($P($P(DIFGDIX,U,3),"=",2),1,$L($P($P(DIFGDIX,U,3),"=",2))-1)),DIFGFLUS="" S:'Y DIFGSKIP(DIFGMULT)="" S DIFG("NOLKUP")=""
	I '$D(DIFG("NOLKUP")) S X=$S($P($P(DIFGDIX,U,3),"=",2)?1"@"1N.N:"`"_$S(^UTILITY("DIFG@",$J,$P($P(DIFGDIX,U,3),"=",2))["^UTILITY":"^"_$P(^($P($P(DIFGDIX,U,3),"=",2)),U,2),1:$P(^($P($P(DIFGDIX,U,3),"=",2)),U)),1:$P($P(DIFGDIX,U,3),"=",2))
	I '$D(DIC) S DIC=$S(+$P(DIFGDIX,U,2):+$P(DIFGDIX,U,2),$D(^DIC("B",$P(DIFGDIX,U))):$O(^DIC("B",$P(DIFGDIX,U),"")),1:"") I DIC S:'$D(^DIC(DIC)) DIC=""
	I 'DIC S DIFGER=20_U_DIFGY D ERROR^DIFG
	I $P(DIFGDIX,U,4)]"" S DIFGXRF(DIFGMULT)=$P(DIFGDIX,U,4)
	Q
	;
FUNC	;CHECKS FUNCTION ON BASE ENTRY LINE
	S DIFGO=DIFGO+1
	S DIFGINCR=DIFGO
	S %=$P(DIFGDIX,U,3),%=$P(%,"="),^UTILITY("DIFG",$J,DIFGINCR,DIC,"MODE")=$S(%?1A:%,1:"L")_"^"_DIFGY S DIFGMO(DIFGMULT)=$P(^("MODE"),U)_"^"_DIC
	K %
	Q
	;
