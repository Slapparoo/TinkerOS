#define TURTLE_SIZE		4
#define TURTLE_SPEED_STEP	2

#define ANGLES	35
F64 angles[ANGLES]={
-2*�/1,-2*�/2,-2*�/3,-2*�/4,-2*�/5,
-2*�/6,-2*�/8,-2*�/9,-2*�/10,
-2*�/12,-2*�/15,-2*�/18,-2*�/20,
-2*�/24,-2*�/30,-2*�/36,-2*�/40,
0,
2*�/40,2*�/36,2*�/30,2*�/24,
2*�/20,2*�/18,2*�/15,2*�/12,
2*�/10,2*�/9,2*�/8,2*�/6,
2*�/5,2*�/4,2*�/3,2*�/2,2*�/1
};

class Turtle
{
  F64 x,y,z,speed,�,w;
  I64 d�_idx;
  CColorROPU16 edge,middle;
  Bool ends,first;
} tt;

U0 TurtlePlot(CDC *dc,Turtle *t,CColorROPU16 edge,CColorROPU16 middle)
{
  F64 w=t->w/2.0-1;
  if (w<0) w=0;
  dc->color=middle;
  GrLine3(dc,t->x+w*Cos(t->�+�/2),t->y+w*Sin(t->�+�/2),t->z,
        t->x+w*Cos(t->�-�/2),t->y+w*Sin(t->�-�/2),t->z);
  w=t->w/2.0;
  dc->color=edge;
  GrPlot3(dc,t->x+w*Cos(t->�+�/2),t->y+w*Sin(t->�+�/2),t->z);
  GrPlot3(dc,t->x+w*Cos(t->�-�/2),t->y+w*Sin(t->�-�/2),t->z);
}

U0 TurtleMicroMove(Turtle *t,F64 dt)
{
  t->x+=dt*t->speed*Cos(t->�);
  t->y+=dt*t->speed*Sin(t->�);
  t->�=Wrap(t->�+dt*angles[t->d�_idx]);
}

U0 TurtleEnd(CDC *dc,Turtle *t,CColorROPU16 edge,CColorROPU16 middle,F64 �)
{
  F64 r,x,y2;
  Turtle t2;
  if (r=t->w) {
    MemCpy(&t2,t,sizeof(Turtle));  //Save
    x=0;
    while (TRUE) {
      t->x+=1/r*Cos(�);
      t->y+=1/r*Sin(�);
      x+=1/r;
      y2=r*r-4*x*x;
      if (y2>=0) {
        t->w=Sqrt(y2);
        TurtlePlot(dc,t,edge,middle);
      } else
        break;
    }
    MemCpy(t,&t2,sizeof(Turtle));
  }
}

U0 TurtleMove(CDC *dc,Turtle *t,CColorROPU16 edge,CColorROPU16 middle)
{
  I64 i,l=16*AbsI64(t->w+1)*AbsI64(t->speed+1);

  if (t->ends && t->first)
    TurtleEnd(dc,t,edge,middle,t->�+�);
  t->first=FALSE;

  for (i=0;i<l;i++) {
    TurtleMicroMove(t,1.0/l);
    TurtlePlot(dc,t,edge,middle);
  }
  if (t->ends)
    TurtleEnd(dc,t,edge,middle,t->�);
}

U0 TurtleInit(Turtle *t)
{
  MemSet(t,0,sizeof(Turtle));
  t->x=Fs->pix_width>>1;
  t->y=Fs->pix_height>>1;
  t->z=5;
  t->edge=BLACK;
  t->middle=YELLOW;
  t->d�_idx=ANGLES/2;
  t->first=TRUE;
  t->ends=TRUE;
}

U0 DrawIt(CTask *,CDC *dc)
{
  Turtle t2;
  MemCpy(&t2,&tt,sizeof(Turtle));
  GrPrint(dc,0,0,"Layer:%f Speed:%f �:%5.1f d�:%5.1f Width:%f",
        tt.z,tt.speed,tt.�*180/�,angles[tt.d�_idx]*180/�,tt.w);

  TurtleMove(dc,&t2,RED,LTRED);
  dc->color=LTRED;
  GrLine(dc,t2.x+TURTLE_SIZE*Cos(t2.�+�/2),t2.y+TURTLE_SIZE*Sin(t2.�+�/2),
        t2.x+TURTLE_SIZE*Cos(t2.�-�/2),t2.y+TURTLE_SIZE*Sin(t2.�-�/2));
  GrLine(dc,t2.x+TURTLE_SIZE*Cos(t2.�+�/2),t2.y+TURTLE_SIZE*Sin(t2.�+�/2),
        t2.x+TURTLE_SIZE*Cos(t2.�),    t2.y+TURTLE_SIZE*Sin(t2.�));
  GrLine(dc,t2.x+TURTLE_SIZE*Cos(t2.�-�/2),t2.y+TURTLE_SIZE*Sin(t2.�-�/2),
        t2.x+TURTLE_SIZE*Cos(t2.�),    t2.y+TURTLE_SIZE*Sin(t2.�));
}

U0 SetMenu()
{
  I64 i;
  U8 buf[STR_LEN];
  CMenuEntry *tmpse;
  for (i=0;i<=9;i++) {
    StrPrint(buf,"Settings/Layer%d",i);
    if (tmpse=MenuEntryFind(Fs->cur_menu,buf)) {
      if (i==tt.z)
        tmpse->checked=TRUE;
      else
        tmpse->checked=FALSE;
    }
  }
  if (tmpse=MenuEntryFind(Fs->cur_menu,"Settings/Ends")) {
    if (tt.ends)
      tmpse->checked=TRUE;
    else
      tmpse->checked=FALSE;
  }
}

U0 Lattice()
{
  Bool aim=FALSE;
  I64 arg1,arg2;
  CDC  *dc=DCAlias;
  DCDepthBufAlloc(dc);
  MenuPush(
        "File {"
        "  Abort(,CH_SHIFT_ESC);"
        "  Exit(,CH_ESC);"
        "}"
        "Play {"
        "  Restart(,'\n');"
        "  Step(,CH_SPACE);"
        "  Accelerator(,,SC_CURSOR_UP);"
        "  Break(,,SC_CURSOR_DOWN);"
        "  Left(,,SC_CURSOR_LEFT);"
        "  Right(,,SC_CURSOR_RIGHT);"
        "}"
        "Settings {"
        "  Color(,'c');"
        "  Wider(,'+');"
        "  Narrower(,'-');"
        "  Ends(,'e');"
        "  Layer0(,'0');"
        "  Layer1(,'1');"
        "  Layer2(,'2');"
        "  Layer3(,'3');"
        "  Layer4(,'4');"
        "  Layer5(,'5');"
        "  Layer6(,'6');"
        "  Layer7(,'7');"
        "  Layer8(,'8');"
        "  Layer9(,'9');"
        "}"
        );
  SettingsPush; //See $LK,"SettingsPush",A="MN:SettingsPush"$
  AutoComplete;
  WinBorder;
  WinMax;
  DocCursor;
  DocClear;
  TurtleInit(&tt);
  SetMenu;
  Fs->win_inhibit=WIG_TASK_DFT-WIF_FOCUS_TASK_MENU
        -WIF_SELF_FOCUS-WIF_SELF_GRAB_SCROLL;
  Fs->draw_it=&DrawIt;
  try {
    while (TRUE) {
      switch (GetMsg(&arg1,&arg2,1<<MSG_KEY_DOWN|1<<MSG_MS_L_DOWN|
	    1<<MSG_MS_R_DOWN|1<<MSG_MS_R_UP|1<<MSG_MS_MOVE)) {
        case MSG_MS_L_DOWN:
	  tt.first=TRUE;
	  tt.x=arg1;
	  tt.y=arg2;
	  break;
        case MSG_MS_R_DOWN:
	  aim=TRUE;
	  tt.�=Arg(arg1-tt.x,arg2-tt.y);
	  break;
        case MSG_MS_MOVE:
	  if (aim)
	    tt.�=Arg(arg1-tt.x,arg2-tt.y);
	  break;
        case MSG_MS_R_UP:
	  tt.�=Arg(arg1-tt.x,arg2-tt.y);
	  aim=FALSE;
	  break;
        case MSG_KEY_DOWN:
	  switch (arg1) {
	    case 0:
	      switch (arg2.u8[0]) {
	        case SC_CURSOR_LEFT:
		  if (tt.d�_idx)
		    tt.d�_idx--;
		  break;
	        case SC_CURSOR_RIGHT:
		  if (tt.d�_idx<ANGLES-1)
		    tt.d�_idx++;
		  break;
	        case SC_CURSOR_UP:
		  tt.speed+=TURTLE_SPEED_STEP;
		  break;
	        case SC_CURSOR_DOWN:
		  if (tt.speed>=TURTLE_SPEED_STEP)
		    tt.speed-=TURTLE_SPEED_STEP;
		  break;
	      }
	      break;
	    case '0'...'9':
	      tt.z=arg1-'0';
	      SetMenu;
	      break;
	    case 'c':
	      tt.middle=PopUpColor("Mid Color\n\n");
	      tt.edge  =PopUpColor("Edge Color\n\n");
	      break;
	    case 'e':
	      tt.ends=!tt.ends;
	      break;
	    case '+':
	      tt.w++;
	      break;
	    case '-':
	      if (tt.w)
	        tt.w--;
	      break;
	    case '\n':
	      DCFill(dc);
	      TurtleInit(&tt);
	      SetMenu;
	      break;
	    case CH_ESC:
	    case CH_SHIFT_ESC:
	      goto lt_done;
	    case CH_SPACE:
	      TurtleMove(dc,&tt,tt.edge,tt.middle);
	      break;
	  }
      }
    }
lt_done:
    GetMsg(,,1<<MSG_KEY_UP);
  } catch
    PutExcept;
  SettingsPop;
  DCFill(dc);
  DCDel(dc);
  MenuPop;
}

Lattice;
