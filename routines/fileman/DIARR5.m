DIARR5	;SFISC/DCM-ARCHIVING(READ ARCHIVED FG)-PRINT REQUEST ;4/8/93  8:00 AM
	;;22.2T0;VA FILEMAN;;Dec 03, 2012
	;Per VHA Directive 10-93-142, this routine should not be modified.
PRINT	I $D(DIARQUED) G Q
	S IOP=DIARPDEV D ^%ZIS G Q:POP
DQ	S DIARPG=0
	F DIARY=0:0 S DIARY=$O(DIARR(DIARY)) Q:DIARY'>0  D HD Q:$D(DTOUT)!($D(DIRUT))  D PRINT1:$D(^TMP("DIARO",$J,DIARY)) W:'$D(^TMP("DIARO",$J,DIARY)) !,?11,"MATCHES FOUND: ",DIARRF(DIARY)
	D ^%ZISC
	Q
	;
PRINT1	F DIARZ=0:0 S DIARZ=$O(^TMP("DIARO",$J,DIARY,DIARZ)) Q:DIARZ'>0!$D(DTOUT)!$D(DIRUT)  W ! F DIARZ1=0:0 S DIARZ1=$O(^TMP("DIARO",$J,DIARY,DIARZ,DIARZ1)) Q:DIARZ1'>0  W ^(DIARZ1),! I $Y>(IOSL-2) D HD Q:$D(DTOUT)!$D(DIRUT)
	W !,?11,"MATCHES FOUND: ",DIARRF(DIARY)
	Q
	;
HD	U IO
	I "C"[$E(IOST) K DIR S DIR(0)="E" D ^DIR Q:$D(DTOUT)!($D(DIRUT))
	S Y=DT X ^DD("DD")
	W:$Y @IOF W "ARCHIVE RETRIEVAL LIST",?60,Y,?72,"PAGE: ",DIARPG+1
HD1	W !,"REQUEST: ",DIARY W:$D(DIARR(DIARY,.01)) !,?2,DIAR01," = ",DIARR(DIARY,.01) D HD2:$D(DIARR(DIARY,"ID"))
	S $P(DIARLINE,"-",IOM)="" W !,DIARLINE,! S DIARPG=DIARPG+1
	Q
	;
HD2	F DIARX1=0:0 S DIARX1=$O(DIARR(DIARY,"ID",DIARX1)) Q:DIARX1'>0  W:DIARX1 !,?2,$P(DIARID(DIARX1),U)," = ",DIARR(DIARY,"ID",DIARX1)
	Q
	;
Q	S ZTRTN="DQ^DIARR5",ZTDTH=$H,ZTSAVE("DIARR(")="",ZTSAVE("^TMP(""DIARO"",$J,")="",ZTSAVE("DIARRF(")="",ZTDESC="RETRIEVAL OF ARCHIVED DATA",ZTIO=DIARPDEV,ZTSAVE("DIAR01")="",ZTSAVE("DIARID(")=""
	D ^%ZTLOAD,HOME^%ZIS
	U IO(0) W !! I '$D(DIARQUED) W:POP "UNABLE TO OPEN SELECTED PRINTER AT THIS TIME.  "
	W "OUTPUT QUEUED!"
	Q
