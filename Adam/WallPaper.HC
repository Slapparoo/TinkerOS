#help_index "Windows"

class CWallPaperGlbls
{
  I64	last_calc_idle_cnt,last_swap_cnter[MP_PROCESSORS_NUM];
  F64	last_calc_idle_delta_time;
  U8	top_line[STR_LEN];
} *wall=CAlloc(sizeof(CWallPaperGlbls));
wall->last_calc_idle_delta_time=1.0;

class CTaskWallPaperData
{
  I64	alloced_u8s,used_u8s;
  U8	caller_stk[STR_LEN-$$];
};

U0 WallPaper(CTask *_task)
{
  I64 i;
  CHashTable *old_hash=Fs->hash_table;
  CCPU *c;
  CDateStruct ds;
  U8 *st;
  _task->text_attr=BLUE<<4+WHITE;

  if (!(winmgr.updates&31) || !*wall->top_line) {
    Date2Struct(&ds,Now+local_time_offset);
    i=sys_code_bp->alloced_u8s-sys_code_bp->used_u8s;
    if (sys_data_bp)
      i+=sys_data_bp->alloced_u8s-sys_data_bp->used_u8s;
    StrPrint(wall->top_line,
	  "%3tZ%02d/%02d%02d:%02d:%02dFPS:%2tfCPU",
	  ds.day_of_week,"ST_DAYS_OF_WEEK",ds.mon,ds.day_of_mon,
	  ds.hour,ds.min,ds.sec,winmgr.fps,i);
  }
  TextPrint(Fs,0,0,BLUE<<4+WHITE,wall->top_line);

  if (scrncast.record)
    TextPrint(Fs,29-4,0,BLUE<<4+RED,"*");
  for (i=0;i<mp_cnt;i++) {
    c=&cpu_structs[i];
    if (i&1)
      TextPrint(Fs,29+i*2,0,BLUE<<4+WHITE,"%2tf",100.0*(1.0-c->idle_factor));
    else
      TextPrint(Fs,29+i*2,0,BLUE<<4+YELLOW,"%2tf",100.0*(1.0-c->idle_factor));
  }

  st=ScanCode2KeyName(kbd.last_down_scan_code);
  TextPrint(Fs,80-18,0,BLUE<<4+YELLOW,"%18ts",st);
  Free(st);

  Fs->hash_table=old_hash;
  wall->last_calc_idle_cnt=winmgr.t->calc_idle_cnt;
}

$SP,"<1>",BI=1$



U0 DrawTermBttn(CDC *dc,CCtrl *c)
{
  if (Blink)
    Sprite3(dc,c->left,c->top,0,$IB,"<1>",BI=1$);
}

U0 LeftClickTermBttn(CCtrl *,I64,I64,Bool down)
{
  if (down)
    User;
}

CCtrl *TermBttnNew()
{
  I64 min_x,max_x,min_y,max_y;
  CCtrl *c=ACAlloc(sizeof(CCtrl));

  c->win_task=sys_winmgr_task;
  c->flags=CTRLF_SHOW;
  c->type=CTRLT_GENERIC;
  c->draw_it=&DrawTermBttn;
  c->left_click=&LeftClickTermBttn;

  SpriteExtents($IB,"<1>",BI=1$,&min_x,&max_x,&min_y,&max_y);
//min must be zero
  c->left=sys_winmgr_task->pix_width-(max_x-min_x+1);
  c->right=c->left+(max_x-min_x+1)-1;
  c->top=sys_winmgr_task->pix_height-(max_y-min_y+1);
  c->bottom=c->top+(max_y-min_y+1)-1;

  QueIns(c,sys_winmgr_task->last_ctrl);
  TaskDerivedValsUpdate(sys_winmgr_task);

  return c;
}

U0 WallPaperInit()
{
  TermBttnNew;
  gr.fp_wall_paper=&WallPaper;
}
        7              (      	      $            Term  