DIEV1	;SFISC/DPC -- VARIABLE POINTER VALIDATION ;1:39 PM  12 Sep 2002
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
VP(DIEVF,DIEVFLD,DIEVFLG,DIEVAL,DIEV0,DIVPOUT)	;
	N DIVPY,DIVPHITF,DIVPZ,DIVPVP,DIVPRNUM,DIVPFILE,DIVPSAVV,DIVPAMB,DIVPFLK
	K DIVPOUT
	S DIVPAMB=0
	I DIEVAL'["."!($P(DIEVAL,".")="") D ALL,DONE Q
	S DIVPSAVV=DIEVAL,DIVPFLK=$P(DIVPSAVV,"."),DIEVAL=$P(DIVPSAVV,".",2,99)
	N DIVPVPS D VPNUMS(DIEVF,DIEVFLD,DIVPFLK,.DIVPVPS)
	I $D(DIVPVPS) D
	. S DIVPVP=""
	. F  S DIVPVP=$O(DIVPVPS(DIVPVP)) Q:DIVPVP=""  D FINDVP Q:DIVPAMB
	I DIVPAMB S DIVPOUT=U Q
	I $D(DIVPY) D DONE Q
	S DIEVAL=DIVPSAVV
	D ALL,DONE
	Q
	;
ALL	;
	N DIVPORD S DIVPORD=0
	F  S DIVPORD=$O(^DD(DIEVF,DIEVFLD,"V","O",DIVPORD)) Q:'DIVPORD  D  Q:DIVPAMB
	. S DIVPVP=$O(^DD(DIEVF,DIEVFLD,"V","O",DIVPORD,""))
	. D FINDVP
	Q
	;
VPNUMS(DIEVF,DIEVFLD,DIVPFLK,DIVPVPS)	;
	I $D(^DD(DIEVF,DIEVFLD,"V","P",DIVPFLK)) S DIVPVPS($O(^(DIVPFLK,"")))="" Q
	N DIVPMES S DIVPMES=""
	F  S DIVPMES=$O(^DD(DIEVF,DIEVFLD,"V","M",DIVPMES)) Q:DIVPMES=""  D
	. I $P(DIVPMES,DIVPFLK)="" S DIVPVPS($O(^DD(DIEVF,DIEVFLD,"V","M",DIVPMES,"")))=""
	S DIVPFILE=0
	F  S DIVPFILE=$O(^DD(DIEVF,DIEVFLD,"V","B",DIVPFILE)) Q:DIVPFILE=""  D
	. I $P($$GET1^DID(DIVPFILE,"","","NAME","","","A"),DIVPFLK)="" S DIVPVPS($O(^DD(DIEVF,DIEVFLD,"V","B",DIVPFILE,"")))=""
	Q
	;
FINDVP	;
	S DIVPZ=^DD(DIEVF,DIEVFLD,"V",DIVPVP,0)
	S DIVPFILE=+DIVPZ Q:'DIVPFILE
	N DIVPECNT S DIVPECNT=$G(DIERR)
	I $P(DIVPZ,U,5)="y",$G(^DD(DIEVF,DIEVFLD,"V",DIVPVP,1))]"" N DIC X ^DD(DIEVF,DIEVFLD,"V",DIVPVP,1)
	I DIVPECNT'=$G(DIERR) D HKERR^DILIBF(DIEVF,"",DIEVFLD,"variable pointer screen") Q
	S DIVPRNUM=$$FIND1^DIC(DIVPFILE,"","BO",DIEVAL,"",$G(DIC("S")))
	I $D(^TMP("DIERR",$J,"E",299)) K DIVPY S DIVPAMB=1
	I 'DIVPRNUM Q
	I DIVPRNUM,'$D(DIVPY) S DIVPY=DIVPRNUM,DIVPHITF=DIVPFILE Q
	I DIVPRNUM,$D(DIVPY) D
	. K DIVPY
	. S DIVPAMB=1
	. N DIVPP S DIVPP(1)=DIEVAL D BLD^DIALOG(299,.DIVPP,.DIVPP)
	Q
	;
DONE	;
	I '$G(DIVPY) S DIVPOUT=U Q
	S DIVPOUT=DIVPY_";"_$E($$GET1^DID(DIVPHITF,"","","GLOBAL NAME","","","A"),2,99)
	D IT
	I DIVPOUT=U Q
	I DIEVFLG["E" S DIVPOUT(0)=$$EXTERNAL^DILFD(DIEVF,DIEVFLD,"",DIVPOUT)
	Q
	;
IT	;
	N X S X=DIVPOUT
	N DIVPECNT S DIVPECNT=$G(DIERR)
	I $G(DIEV0) X $P(DIEV0,U,5,99)
	I '$G(DIEV0) X $P(^DD(DIEVF,DIEVFLD,0),U,5,99)
	I DIVPECNT'=$G(DIERR) S DIVPOUT=U D HKERR^DILIBF(DIEVF,"",DIEVFLD,"input transform") Q
	S DIVPOUT=$G(X,U)
	Q
	;
VPFILES(DIEVF,DIEVFLD,DIVPFLK,DIVPANS)	;
	N DIVPVPS,DIEVFILE
	D VPNUMS(DIEVF,DIEVFLD,DIVPFLK,.DIVPVPS)
	I '$D(DIVPVPS) Q
	N DIVPVP S DIVPVP=""
	F  S DIVPVP=$O(DIVPVPS(DIVPVP)) Q:DIVPVP=""  D
	. S DIVPANS(+^DD(DIEVF,DIEVFLD,"V",DIVPVP,0))=""
	Q
