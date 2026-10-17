typedef unsigned char   undefined;

typedef unsigned char    undefined1;
typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned long long    undefined6;
typedef unsigned long long    undefined8;
typedef unsigned char    byte;


int DAT_00000904;

/* Original: FUN_00000006; source: ID04.c. Recovered name: disable_dialog_control [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x6.
 * GetDItem(dialog, item, &type, &handle, &box) ($A98D) then HiliteControl(handle, 255) ($A95D): dims the control. Args (C stack): +8 DialogPtr, +0xc short item. Callers: ID04 0x2ea0, 0x2eae (show_mission_summary_dialog).
 */
// WARNING: Control flow encountered bad instruction data

void disable_dialog_control /* Original: FUN_00000006 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_0000002e; source: ID04.c. Recovered name: enable_dialog_control [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x2e.
 * GetDItem ($A98D) then HiliteControl(handle, 0) ($A95D): re-enables the control. Args: +8 DialogPtr, +0xc short item. Callers: ID04 0x1952, 0x1966.
 */
// WARNING: Control flow encountered bad instruction data

void enable_dialog_control /* Original: FUN_0000002e */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00000054; source: ID04.c. Recovered name: hide_dialog_control [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x54.
 * GetDItem ($A98D) then HideControl(handle) ($A958). Args: +8 DialogPtr, +0xc short item. Callers: ID04 0x2f20, 0x2f2e, 0x2fce.
 */
// WARNING: Control flow encountered bad instruction data

void hide_dialog_control /* Original: FUN_00000054 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00000078; source: ID04.c. Recovered name: show_dialog_control [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x78.
 * GetDItem ($A98D) then ShowControl(handle) ($A957). Args: +8 DialogPtr, +0xc short item. Callers: ID04 0x2f66, 0x2f74.
 */
// WARNING: Control flow encountered bad instruction data

void show_dialog_control /* Original: FUN_00000078 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_0000009c; source: ID04.c. Recovered name: set_dialog_item_text [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x9c.
 * GetDItem ($A98D) then SetIText(handle, text) ($A98F). Args: +8 DialogPtr, +0xc short item, +0xe Pascal string pointer. Callers: ID04 0x2dda, 0x35ec, 0x37e4, 0x38b0.
 */
// WARNING: Control flow encountered bad instruction data

void set_dialog_item_text /* Original: FUN_0000009c */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000000c4; source: ID04.c. Recovered name: set_dialog_control_title [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0xc4.
 * GetDItem ($A98D) then SetCTitle(handle, title) ($A95F). Args: +8 DialogPtr, +0xc short item, +0xe Pascal string pointer. Caller: ID04 0x2ece (show_mission_summary_dialog, item 3).
 */
// WARNING: Control flow encountered bad instruction data

void set_dialog_control_title /* Original: FUN_000000c4 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000000ec; source: ID04.c. Recovered name: set_dialog_user_item_proc [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0xec.
 * GetDItem ($A98D) then SetDItem(dialog, item, type, proc, &box) ($A98E): keeps type and box, replaces the item handle with a user-item procedure pointer. Args: +8 DialogPtr, +0xc short item, +0xe ProcPtr. 14 callers in ID04 (e.g. 0x8a6 item 0x27 and 0x13ba item 8 with JT $142 = draw_grey_user_item; 0x2e40.. with JT $aa).
 */
// WARNING: Control flow encountered bad instruction data

void set_dialog_user_item_proc /* Original: FUN_000000ec */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00000120; source: ID04.c. Recovered name: frame_dialog_item_box [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x120.
 * Saves thePort (A5-0x160c), SetPort(dialog) ($A873), GetDItem, InsetRect(&box, -2, -2) ($A8A9), PenSize(1, 1) ($A89B), FrameRect(&box) ($A8A1), restores the port. Draws a 1-pixel frame 2 pixels outside the item. Args: +8 DialogPtr, +0xc short item. Callers: ID04 0x1daa, 0x1df0, 0x1f70, 0x33ec.
 */
// WARNING: Control flow encountered bad instruction data

void frame_dialog_item_box /* Original: FUN_00000120 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_0000016e; source: ID04.c. Recovered name: draw_default_button_outline [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x16e.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes). Ignores its item argument and uses the word at A5-0x225e: GetDItem, PenSize(3, 3), InsetRect(&box, -4, -4), FrameRoundRect(&box, 16, 16) ($A8B0) - the standard bold default-button ring. Reached through JT $12a (ID00 entry -> ID04 0x16e). The unexported routine at ID04 0x1b8 installs JT $12a as a user item with SetDItem and stores the default-button item number in A5-0x225e [PROVEN, bytes 0x1de/0x1e8].
 */
// WARNING: Control flow encountered bad instruction data

void draw_default_button_outline /* Original: FUN_0000016e */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000001f2; source: ID04.c. Recovered name: draw_grey_user_item [PROVEN] (iteration 181).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x1f2.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes): GetDItem then FillRect(&box, gray) ($A8A5) with the QuickDraw pattern at A5-0x1624 (gray, next to white -0x1614 / black -0x161c) [STRONG INFERENCE for gray]. Reached through JT $142, installed by set_dialog_user_item_proc at ID04 0x8a6 and 0x13ba. [HYPOTHESIS] a grey separator / divider in a dialog.
 */
// WARNING: Control flow encountered bad instruction data

void draw_grey_user_item /* Original: FUN_000001f2 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000220(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_000002c0(void)

{
  code *UNRECOVERED_JUMPTABLE;
  
  FUN_00000220();
                    // WARNING: Could not recover jumptable at 0x000002da. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



// WARNING: Control flow encountered bad instruction data

undefined4 FUN_00000362(undefined4 param_1,undefined4 param_2,undefined4 param_3)

{
  if (param_3._0_2_ < 1) {
    return 0xffffffff;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000003c2; source: ID04.c:164.
 * Recovered name: run_with_temporary_window [STRONG INFERENCE mechanics]
 * (iteration 172). Ghidra truncated at $A8A9. Bytes 0x3c2..0x430 [PROVEN]:
 *   if (long A5-0x225a == 0) {
 *     A5-0x14be = screenBits.bounds (A5-0x1680, 8 bytes); r = that;
 *     InsetRect(&r, 100, 100) $A8A9;
 *     A5-0x225a = NewWindow(nil, &r, title = STR# 129 slot 62 "Hellcats"
 *       (long A5-0xe4e), visible, procID 3, (WindowPtr)-1, goAway, 0) $A913;
 *   }
 *   SetPort(w) $A873; ShowWindow(w) $A915; JT $4aa (ID02 file 0x2db8,
 *   not yet named); HideWindow(w) $A916.
 * The window is created once and only shown around the ID02 call.
 * Note: the following unexported routine at file 0x432..0x44c (no Ghidra
 * entry) is the user of STR# 129 slot 1: if word A5-0x14a0 { JT $462 (ID02
 * 0x4d34); show_caution_alert_with_number(slot 1 "Unable to store instrument
 * panel to disk", 0); A5-0x14a0 = 0 } [PROVEN, bytes].
 */
void run_with_temporary_window /* Original: FUN_000003c2 */ (void)

{
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x225a) == 0) {
    *(undefined4 *)(unaff_A5 + -0x14be) = *(undefined4 *)(unaff_A5 + -0x1680);
    *(undefined4 *)(unaff_A5 + -0x14ba) = *(undefined4 *)(unaff_A5 + -0x167c);
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000044e(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00000478(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000004f0; source: ID04.c:205.
 * Recovered name: ask_save_changes [STRONG INFERENCE] (iteration 175).
 * JT $ba. Bytes 0x4f0..0x514 [PROVEN]: JT $47a(0x101) (ID02 0x442e, alert
 * centring as in show_caution_alert_with_number); return CautionAlert(257, nil)
 * $A988. ALRT 257 "Save Changes" / DITL 257 [PROVEN, resource dump in
 * artifacts/reverse-engineering/resources/resource_dasm_Hellcats_app]: item 1 "Save", 2 "Cancel", 3 "Don't Save" - matches the
 * quit_application switch (1 save, 2 cancel, else discard).
 */
void ask_save_changes /* Original: FUN_000004f0 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x47a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000516; source: ID04.c:219.
 * Recovered name: confirm_end_mission [STRONG INFERENCE] (iteration 175).
 * JT $13a. Bytes 0x516..0x55e [PROVEN]:
 *   if (word A5-0x12f8 < 3 || word A5-0x14c4 != 0) return 2;   [no mission]
 *   if (FUN_000018e0() == 0) return 2;
 *   JT $47a(0x103); return CautionAlert(259, nil).
 * ALRT 259 "Really End Mission" / DITL 259 [PROVEN, dump]: item 1 "Cancel",
 * 2 "End Mission"; text "Are you sure you want to end the current mission
 * now?  (You will collect no points)". 2 = proceed. Callers: quit_application
 * (ID02 0x2eaa) and do_menu_command menu 2 item 9 (End Mission).
 * A5-0x12f8 >= 3 && A5-0x14c4 == 0 therefore means "mission in progress"
 * [STRONG INFERENCE].
 */
undefined4 confirm_end_mission /* Original: FUN_00000516 */ (void)

{
  bool bVar1;
  undefined4 uVar2;
  int unaff_A5;
  
  if ((*(short *)(unaff_A5 + -0x12f8) < 3) || (*(short *)(unaff_A5 + -0x14c4) != 0)) {
    bVar1 = false;
  }
  else {
    bVar1 = true;
  }
  if (bVar1) {
    uVar2 = get_mission_kill_report_state();
    if ((short)uVar2 != 0) {
      (**(code **)(unaff_A5 + 0x47a))();
                    // WARNING: Bad instruction - Truncating control flow here
      halt_baddata();
    }
  }
  return 2;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00000560; source: ID04.c:247.
 * Recovered name: confirm_erase_high_scores [STRONG INFERENCE] (iteration 175).
 * Bytes 0x560..0x584 [PROVEN]: JT $47a(0x104); return CautionAlert(260, nil).
 * ALRT 260 "Erase Hi Score" / DITL 260 [PROVEN, dump]: item 1 "Cancel",
 * 2 "Erase"; text "Are you sure you want to erase all non-active duty high
 * scores?". Ghidra lost the return value.
 */
void confirm_erase_high_scores /* Original: FUN_00000560 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x47a))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00000588; source: ID04.c:259.
 * Recovered name: compute_pilot_score [STRONG INFERENCE] (iteration 176).
 * Exported C complete. Arg: word record index i.
 *   score = sum over k < 12 of (short) record[i].tally[k] * (short) weight[k]
 *   record = *(HEL1 128 handle A5-0x13a8) + i * 0x40, tallies at +0x28
 *   (12 words); weights = 12 words at A5-0xf5e (A5 initial data, not read).
 * HEL1 128 is named "Player and Score Data" in the resource dump (20 records
 * of 0x40 bytes; the shipped copy is all zero = empty roster) [PROVEN, dump].
 * Related string groups (ID07 init_string_pointer_groups) [PROVEN, dump]:
 *   A5-0xffe  slots 94-99  ranks: Ensign, Lt. Junior Grade, Lieutenant,
 *             Lt. Commander, Commander, Captain   (indexed by record +0x22)
 *   A5-0xfae  slots 100-105 status: Active, Dead, Retired, POW, Discharged, MIA
 *   A5-0xf86  slots 106-115 targets: Fighter, Bomber, Tank, AAA Battery,
 *             Vehicle, Carrier, Battleship, Cruiser, PT Boat, Runway
 * [HYPOTHESIS] tallies 0..9 count destroyed targets of those categories;
 * the remaining two tallies are UNKNOWN.
 */
int compute_pilot_score /* Original: FUN_00000588 */ (undefined4 param_1)

{
  int unaff_A5;
  undefined4 local_a;
  undefined2 local_6;
  
  local_a = 0;
  for (local_6 = 0; local_6 < 0xc; local_6 = local_6 + 1) {
    local_a = (int)*(short *)(local_6 * 2 + **(int **)(unaff_A5 + -0x13a8) + param_1._0_2_ * 0x40 +
                             0x28) * (int)*(short *)(local_6 * 2 + unaff_A5 + -0xf5e) + local_a;
  }
  return local_a;
}



// WARNING: Control flow encountered bad instruction data

void FUN_000005e4(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x2a))();
  (**(code **)(unaff_A5 + 0x32))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000009ee(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



undefined4 FUN_00000a8e(undefined4 param_1,int param_2,undefined2 *param_3)

{
  undefined4 uVar1;
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x2a))();
  if (((*(uint *)(param_2 + 2) & 0xff) == 0xd) || ((*(uint *)(param_2 + 2) & 0xff) == 3)) {
    *param_3 = 1;
    uVar1 = 1;
  }
  else {
    uVar1 = 0;
  }
  return uVar1;
}



void FUN_00000bda(undefined2 *param_1,int param_2,undefined4 param_3)

{
  undefined4 uVar1;
  code *UNRECOVERED_JUMPTABLE;
  undefined1 uStack00000010;
  
  uVar1 = FUN_00000a8e(param_3,param_2,param_1);
  uStack00000010 = (undefined1)uVar1;
                    // WARNING: Could not recover jumptable at 0x00000c00. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



void FUN_00000e48(undefined2 *param_1,int param_2,undefined4 param_3)

{
  undefined4 uVar1;
  code *UNRECOVERED_JUMPTABLE;
  undefined1 uStack00000010;
  
  uVar1 = FUN_00000a8e(param_3,param_2,param_1);
  uStack00000010 = (undefined1)uVar1;
                    // WARNING: Could not recover jumptable at 0x00000e6e. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/*
 * Original: FUN_00000f4e; source: ID04.c:355.
 * Recovered name: rank_pilots_by_score [STRONG INFERENCE] (iteration 177).
 * Exported C complete (control flow partly via labels). Args: long scores[20]
 * (param_1), short order[20] (param_2). For i < 20: scores[i] =
 * compute_pilot_score(i), order[i] = i; then sorts order by scores (pairwise
 * comparisons over 0x14 entries; equal scores compare the two records'
 * names via pcVar2/pcVar3 [HYPOTHESIS: tie-break]). Used to build the
 * high-score list.
 */
void rank_pilots_by_score /* Original: FUN_00000f4e */ (int param_1,int param_2)

{
  undefined4 uVar1;
  char *pcVar2;
  char *pcVar3;
  int iVar4;
  int unaff_A5;
  short *psVar5;
  undefined1 *puVar6;
  undefined1 *puVar7;
  undefined4 uStackY_26;
  short local_22 [2];
  undefined4 local_1e;
  undefined2 uVar8;
  undefined2 uStack_16;
  short local_8;
  short local_6;
  
  puVar7 = &stack0xffffffe8;
  for (local_6 = 0; local_6 < 0x14; local_6 = local_6 + 1) {
    iVar4 = param_1 + local_6 * 4;
    uVar8 = (undefined2)((uint)iVar4 >> 0x10);
    uStack_16 = (undefined2)iVar4;
    iVar4 = compute_pilot_score(CONCAT22(local_6,uVar8));
    *(int *)CONCAT22(uVar8,uStack_16) = iVar4;
    *(short *)(param_2 + local_6 * 2) = local_6;
  }
  local_6 = 0;
  do {
    local_8 = local_6;
    if (0x12 < local_6) {
      return;
    }
LAB_000010ea:
    local_8 = local_8 + 1;
    if (local_8 < 0x14) {
      pcVar2 = (char *)(**(int **)(unaff_A5 + -0x13a8) + *(short *)(param_2 + local_6 * 2) * 0x40);
      pcVar3 = (char *)(**(int **)(unaff_A5 + -0x13a8) + *(short *)(param_2 + local_8 * 2) * 0x40);
      puVar6 = puVar7;
      if (*(int *)(param_1 + local_8 * 4) <= *(int *)(param_1 + local_6 * 4)) break;
      goto LAB_00001060;
    }
    local_6 = local_6 + 1;
  } while( true );
  if (*(int *)(param_1 + local_8 * 4) == *(int *)(param_1 + local_6 * 4)) {
    if (*pcVar2 != '\0') {
      if ((*pcVar2 == '\0') || (*pcVar3 == '\0')) goto LAB_000010ea;
      *(undefined2 *)(puVar7 + -2) = 0;
      *(char **)(puVar7 + -6) = pcVar2;
      psVar5 = (short *)(puVar7 + -10);
      *(char **)(puVar7 + -10) = pcVar3;
      *(undefined4 *)(puVar7 + -0xe) = 0x1058;
      (**(code **)(unaff_A5 + 0x2ea))();
      puVar6 = puVar7 + -8;
      puVar7 = puVar7 + -8;
      if (*psVar5 < 0) goto LAB_000010ea;
    }
LAB_00001060:
    uVar1 = *(undefined4 *)(param_1 + local_8 * 4);
    *(undefined4 *)(param_1 + local_8 * 4) = *(undefined4 *)(param_1 + local_6 * 4);
    *(undefined4 *)(param_1 + local_6 * 4) = uVar1;
    uVar8 = *(undefined2 *)(param_2 + local_8 * 2);
    *(undefined2 *)(param_2 + local_8 * 2) = *(undefined2 *)(param_2 + local_6 * 2);
    *(undefined2 *)(param_2 + local_6 * 2) = uVar8;
    puVar7 = puVar6;
  }
  goto LAB_000010ea;
}



/*
 * Original: FUN_00001106; source: ID04.c:427.
 * Recovered name: reset_pilot_record [STRONG INFERENCE] (iteration 177).
 * Exported C complete. Arg: word i. record = *(HEL1 128) + i * 0x40:
 * clears words +0x20, +0x22 (rank), +0x24, +0x26 and the 12 tallies at +0x28.
 * The name at +0x00 is not cleared here.
 */
void reset_pilot_record /* Original: FUN_00001106 */ (undefined4 param_1)

{
  undefined1 *puVar1;
  int unaff_A5;
  short local_6;
  
  puVar1 = (undefined1 *)(**(int **)(unaff_A5 + -0x13a8) + param_1._0_2_ * 0x40);
  *(undefined2 *)(puVar1 + 0x22) = 0;
  *(undefined2 *)(puVar1 + 0x20) = 0;
  *(undefined2 *)(puVar1 + 0x24) = 0;
  *(undefined2 *)(puVar1 + 0x26) = 0;
  for (local_6 = 0; local_6 < 0xc; local_6 = local_6 + 1) {
    *(undefined2 *)(puVar1 + local_6 * 2 + 0x28) = 0;
  }
  *puVar1 = 0;
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_0000116a(int param_1)

{
  bool bVar1;
  short sVar2;
  bool bVar3;
  int unaff_A5;
  undefined2 uVar4;
  undefined2 local_8;
  undefined2 local_6;
  
  uVar4 = (undefined2)((uint)*(undefined4 *)(unaff_A5 + -0x13a8) >> 0x10);
  (**(code **)(unaff_A5 + 0x272))((short)*(undefined4 *)(unaff_A5 + -0x13a8));
  local_8 = 0;
  bVar3 = false;
  for (local_6 = 0; local_6 < 0x14; local_6 = local_6 + 1) {
    if ((*(short *)(**(int **)(unaff_A5 + -0x13a8) + *(short *)(param_1 + local_6 * 2) * 0x40 + 0x20
                   ) != 0) && (sVar2 = local_8 + 1, bVar1 = 9 < local_8, local_8 = sVar2, bVar1)) {
      reset_pilot_record(CONCAT22(*(undefined2 *)(param_1 + local_6 * 2),uVar4));
      bVar3 = true;
    }
  }
  (**(code **)(unaff_A5 + 0x27a))((short)*(undefined4 *)(unaff_A5 + -0x13a8));
  if (bVar3) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00001200(void)

{
  undefined1 auStack_98 [40];
  undefined1 auStack_70 [108];
  
  rank_pilots_by_score((int)auStack_70,(int)auStack_98);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000014a0; source: ID04.c. Recovered name: draw_scrolling_text_item [PROVEN] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x14a0.
 * Args (C): +8 DialogPtr, +0xc short item. GetDItem ($A98D) -> box; EraseRect(&(*A5-0x223a)->viewRect) ($A8A3, TERec +8); TEUpdate(&box, A5-0x223a) ($A9D3); InsetRect(&box, -2, -2), PenSize(1, 1), FrameRect(&box) ($A8A1). Redraws the scrolling text field and its 1-pixel frame. Caller: draw proc 0x14f2.
 */
// WARNING: Control flow encountered bad instruction data

void draw_scrolling_text_item /* Original: FUN_000014a0 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000014f2; source: ID04.c. Recovered name: scrolling_text_user_item_proc [PROVEN] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x14f2.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; RTS after popping 6 bytes, which Ghidra read as an unrecoverable jump table). Calls draw_scrolling_text_item(dialog, item). Reached through JT $92 (CODE 0 entry -> ID04 0x14f2), installed by create_scrolling_text_item.
 */
void scrolling_text_user_item_proc /* Original: FUN_000014f2 */ (void)

{
  code *UNRECOVERED_JUMPTABLE;
  
  draw_scrolling_text_item();
                    // WARNING: Could not recover jumptable at 0x0000150c. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Original: FUN_0000150e; source: ID04.c. Recovered name: sync_text_scroll_to_control [PROVEN] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x150e.
 * TERec of A5-0x223a: delta = viewRect.top (+8) - destRect.top (+0) - GetCtlValue(A5-0x2236) ($A960) * lineHeight (+0x18); if delta != 0, TEScroll(0, delta, hTE) ($A9DD). Scrolls the text so that its first visible line equals the scroll-bar value. Callers: 0x159e, 0x162c, 0x1744, 0x17ba.
 */
// WARNING: Control flow encountered bad instruction data

void sync_text_scroll_to_control /* Original: FUN_0000150e */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00001562; source: ID04.c. Recovered name: update_scroll_bar_maximum [PROVEN] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x1562.
 * No frame (saves D7 only). max = nLines (TERec +0x5e) - visible lines (A5-0x2232), clamped to >= 0; SetCtlMax(A5-0x2236, max) ($A965). Caller: 0x159a.
 */
// WARNING: Control flow encountered bad instruction data

void update_scroll_bar_maximum /* Original: FUN_00001562 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_0000158c; source: ID04.c. Recovered name: scroll_text_to_show_selection [STRONG INFERENCE] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x158c.
 * Calls update_scroll_bar_maximum and sync_text_scroll_to_control. Then, with v = GetCtlValue ($A960) and the TERec lineStarts array (+0x60): if selStart (+0x20) is before lineStarts[v] or at/after lineStarts[v + visible lines (A5-0x2232)], it finds the line d5 containing selStart, SetCtlValue(ctl, d5 - visible/2) ($A963) and syncs again (centres the insertion line). Callers: append_line_to_scrolling_text 0x18d8 and others. Ghidra stopped after the first two calls.
 */
// WARNING: Control flow encountered bad instruction data

void scroll_text_to_show_selection /* Original: FUN_0000158c */ (void)

{
  update_scroll_bar_maximum();
  sync_text_scroll_to_control();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00001638; source: ID04.c. Recovered name: fit_text_view_to_box [PROVEN] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x1638.
 * Arg +8: Rect *box. On TERec A5-0x223a: viewRect (+8) = *box; viewRect.right (+0xe) -= 16 (scroll-bar width); visible lines A5-0x2232 = viewRect height / lineHeight (+0x18); viewRect.bottom = viewRect.top + lineHeight * visible lines (whole lines only); destRect.right (+6) = viewRect.right; TECalText(hTE) ($A9D0). Caller: create_scrolling_text_item 0x1878. Ghidra stopped before TECalText.
 */
// WARNING: Control flow encountered bad instruction data

void fit_text_view_to_box /* Original: FUN_00001638 */ (undefined4 *param_1)

{
  int iVar1;
  int *piVar2;
  int unaff_A5;
  
  piVar2 = *(int **)(unaff_A5 + -0x223a);
  iVar1 = *piVar2;
  *(undefined4 *)(iVar1 + 8) = *param_1;
  *(undefined4 *)(iVar1 + 0xc) = param_1[1];
  *(short *)(*piVar2 + 0xe) = *(short *)(*piVar2 + 0xe) + -0x10;
  *(short *)(unaff_A5 + -0x2232) =
       (short)(*(short *)(*piVar2 + 0xc) - *(short *)(*piVar2 + 8)) / *(short *)(*piVar2 + 0x18);
  *(short *)(*piVar2 + 0xc) =
       *(short *)(*piVar2 + 8) + *(short *)(*piVar2 + 0x18) * *(short *)(unaff_A5 + -0x2232);
  *(undefined2 *)(*piVar2 + 6) = *(undefined2 *)(*piVar2 + 0xe);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000016c4; source: ID04.c. Recovered name: scroll_bar_action_proc [PROVEN] (iteration 183).
 * Decoded from ID04.bin bytes at file 0x16c4.
 * Pascal control action procedure (ControlHandle at +0xa, part code at +8; pops 6 bytes). Reached through JT $16a (CODE 0 entry -> ID04 0x16c4), passed to TrackControl by the click handler at 0x1752. If part != 0: page = visible lines - 1, then a switch through the ID01 helper (JSR $3a(A5)); its inline table at file 0x16fe is lo 20, hi 23, default +0x2c, cases 20 inUpButton -> -1, 21 inDownButton -> +1, 22 inPageUp -> -page, 23 inPageDown -> +page. Ghidra decoded that table as the three "*unaff_A4 |= ..." lines below (artifact, not real stores). Then SetCtlValue(ctl, GetCtlValue(ctl) + delta) and sync_text_scroll_to_control. The default path (part outside 20..23) adds the uninitialised local delta (original behaviour, bytes 0x1702/0x172e).
 * The code that follows in this Ghidra range (file 0x1752..0x17e4, not exported as a function) is the click handler: C args +8 DialogPtr, +0xc EventRecord *; GetPort/SetPort, GlobalToLocal(where) ($A871), FindControl ($A96C); returns 0 when no control or another control is hit; on the scroll bar A5-0x2236: inThumb (129) -> TrackControl(ctl, where, NULL) ($A968) then sync, else TrackControl(ctl, where, JT $16a); returns 1 when handled; restores the port [PROVEN, bytes].
 */
// WARNING: Control flow encountered bad instruction data

void scroll_bar_action_proc /* Original: FUN_000016c4 */ (undefined4 param_1)

{
  byte *unaff_A4;
  int unaff_A5;
  code *UNRECOVERED_JUMPTABLE;
  
  if (param_1._0_2_ != 0) {
    (**(code **)(unaff_A5 + 0x3a))
              ((short)(*(short *)(**(int **)(unaff_A5 + -0x223a) + 0xc) -
                      *(short *)(**(int **)(unaff_A5 + -0x223a) + 8)) /
               *(short *)(**(int **)(unaff_A5 + -0x223a) + 0x18) + -1);
    *unaff_A4 = *unaff_A4 | 0x17;
    unaff_A4[0xe] = unaff_A4[0xe] | 8;
    *unaff_A4 = *unaff_A4 | 0x1e;
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Could not recover jumptable at 0x00001750. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Original: FUN_000017e6; source: ID04.c. Recovered name: create_scrolling_text_item [STRONG INFERENCE] (iteration 182).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x17e6.
 * Args (C): +8 DialogPtr, +0xc short item. GetDItem ($A98D) -> box; scroll-bar rect = box with left = box.right - 16, InsetRect(0, -2) ($A8A9), OffsetRect(2, 0) ($A8A8). GetPort/SetPort(dialog). TENew(&box, &box) ($A9D2) -> TEHandle A5-0x223a [PROVEN]. NewControl(dialog, &barRect, title A5-0x213c, visible 1, value/min/max 0, procID 16 = scrollBarProc, refCon 0) ($A954) -> ControlHandle A5-0x2236 [PROVEN]. JSR 0x1638 (FUN_00001638, adjusts the TE rects to the box, -16 right). Installs JT $92 (-> ID04 0x14f2) as the item user-item procedure via set_dialog_user_item_proc, then restores the port. Caller: show_mission_summary_dialog 0x2ebc. [STRONG INFERENCE] the scrolling text field of DLOG 133 (mission awards / narrative, cf. its "Skip Text" button).
 */
// WARNING: Control flow encountered bad instruction data

void create_scrolling_text_item /* Original: FUN_000017e6 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_0000189c; source: ID04.c. Recovered name: dispose_scrolling_text_item [PROVEN] (iteration 182).
 * Ghidra could not decode this body (halt_baddata); decoded from ID04.bin
 * bytes at file 0x189c.
 * TEDispose(A5-0x223a) ($A9CD) then DisposeControl(A5-0x2236) ($A955): releases what create_scrolling_text_item allocated. No direct JSR found in ID04 bytes [UNKNOWN caller path].
 */
// WARNING: Control flow encountered bad instruction data

void dispose_scrolling_text_item /* Original: FUN_0000189c */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000018b0; source: ID04.c. Recovered name: append_line_to_scrolling_text [STRONG INFERENCE] (iteration 182).
 * Ghidra truncated this body after the first call (halt_baddata); decoded from ID04.bin
 * bytes at file 0x18b0.
 * Arg +0xe: C string. JSR $522(A5) = ID02 0x3e8 (strlen: counts bytes to NUL) [PROVEN]; TEInsert(text, len, A5-0x223a) ($A9DE); TEInsert(A5-0x213a, 1, A5-0x223a) inserts one separator byte (probably CR) [HYPOTHESIS for CR]; then JSR 0x158c (FUN_0000158c, scroll-bar value / scroll update via GetCtlValue $A960, SetCtlValue $A963). Args +8..+0xd are not used. No direct JSR found in ID04 bytes [UNKNOWN caller path].
 */
// WARNING: Control flow encountered bad instruction data

void append_line_to_scrolling_text /* Original: FUN_000018b0 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x522))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000018e0; source: ID04.c. Recovered name: get_mission_kill_report_state [STRONG INFERENCE] (iteration 184).
 * Decoded from ID04.bin bytes at file 0x18e0.
 * Returns 0 when the mission state A5-0x12f8 == 2; 2 when A5-0x14c0 == 0 and A5-0x12ba > 0; 1 when any of the ten words at A5-0x12ce is non-zero; otherwise 0 [PROVEN, bytes 0x18e4..0x192a]. Ten words = ten target types (STR# 129 slots 106-115) [STRONG INFERENCE: per-mission kill counts]. Callers: confirm_end_mission 0x532 (result 0 -> returns 2 without asking), summary text builders 0x263a and 0x29b6; at 0x29c4 a 0 result appends STR# slot 50 "No new kills to report." (A5-0xe7e). Meaning of state 2 (A5-0x14c0 / A5-0x12ba) [UNKNOWN].
 */
undefined4 get_mission_kill_report_state /* Original: FUN_000018e0 */ (void)

{
  undefined4 uVar1;
  int unaff_A5;
  short local_6;
  
  if (*(short *)(unaff_A5 + -0x12f8) == 2) {
    uVar1 = 0;
  }
  else if ((*(short *)(unaff_A5 + -0x14c0) == 0) && (0 < *(short *)(unaff_A5 + -0x12ba))) {
    uVar1 = 2;
  }
  else {
    for (local_6 = 0; local_6 < 10; local_6 = local_6 + 1) {
      if (*(short *)(local_6 * 2 + unaff_A5 + -0x12ce) != 0) {
        return 1;
      }
    }
    uVar1 = 0;
  }
  return uVar1;
}



/* Original: FUN_0000192e; source: ID04.c. Recovered name: update_summary_dialog_buttons [STRONG INFERENCE] (iteration 184).
 * Decoded from ID04.bin bytes at file 0x192e.
 * C args: +8 DialogPtr, +0xc short phase. Clears A5-0x2230. Calls enable_dialog_control(dialog, 3) unless (mission-over flag A5-0x14c4 set, A5-0x12f0 == 0 and A5-0x2228 == -1); calls enable_dialog_control(dialog, 1) when A5-0x12f0 == 0. If phase != 3, A5-0x14c4 set, A5-0x2228 == -1 and the default item A5-0x225e != 1: SetPort(dialog), then for the current default item and for item 1 GetDItem, InsetRect(-4, -4), EraseRect ($A8A3), InvalRect ($A928); sets A5-0x225e = 1 and restores the port, so draw_default_button_outline redraws the ring around item 1 [PROVEN, bytes 0x1932..0x1a0c]. Ghidra truncated the ring-moving block. In DITL 133 (dump items are 0-based, Toolbox items 1-based) item 1 is "End Mission" and item 3 is "OK" [PROVEN for DITL 133; STRONG INFERENCE that this dialog is DLOG 133]. Callers: 0x21b8 (phase 0) and 0x3050, both after FUN_000021d6 returns non-zero.
 */
// WARNING: Control flow encountered bad instruction data

void update_summary_dialog_buttons /* Original: FUN_0000192e */ (undefined4 param_1,undefined4 param_2)

{
  int unaff_A5;
  
  *(undefined4 *)(unaff_A5 + -0x2230) = 0;
  if (((*(short *)(unaff_A5 + -0x14c4) == 0) || (*(short *)(unaff_A5 + -0x12f0) != 0)) ||
     (*(short *)(unaff_A5 + -0x2228) != -1)) {
    enable_dialog_control();
  }
  if (*(short *)(unaff_A5 + -0x12f0) == 0) {
    enable_dialog_control();
  }
  if (((param_2._0_2_ != 3) && (*(short *)(unaff_A5 + -0x14c4) != 0)) &&
     ((*(short *)(unaff_A5 + -0x2228) == -1 && (*(short *)(unaff_A5 + -0x225e) != 1)))) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00001a0e; source: ID04.c:699.
 * Recovered name: build_rank_and_name_string [STRONG INFERENCE] (iteration 177).
 * Exported C kept (truncated). For the current pilot (word A5-0x13a4):
 * rank = rank-group string A5-0xffe[record +0x22] (Ensign ... Captain);
 * p2cstr(rank) (JT $2fa); buf = copy of rank (JT $52a); append A5-0x2138
 * (separator, JT $512); append p2cstr(record name at +0x00); converts the
 * name, rank and buf back with c2pstr (JT $302) - e.g. "Lieutenant <name>"
 * [STRONG INFERENCE; JT $512 assumed strcat-like].
 * Iteration 187 additions: JT $512 is strcat (ID02 0x2d8 bytes) [PROVEN].
 * The function is also a Pascal user-item procedure: it pops 6 bytes
 * (DialogPtr +0xa, item +8), is reached through JT $7a (-> ID04 0x1a0e) and
 * is installed for item 9 of the Mission Summary (dump item 8, title strip
 * (110,5)-(391,21)); after building the string it calls GetDItem,
 * StringWidth ($A88C), GetFontInfo ($A88B), EraseRect, MoveTo ($A893) and
 * DrawString ($A884) - it draws "rank name" in that item [PROVEN traps;
 * exact centring arithmetic not re-derived]. The name is kept for
 * traceability; "draw_rank_and_name_item" would describe it more fully.
 * The following bytes 0x1b3e..0x1bc6 (not exported by Ghidra) are
 * draw_rank_insignia [STRONG INFERENCE name]: Pascal user item reached through
 * JT $15a (-> ID04 0x1b3e), installed for item 15 (dump item 14, 32 x 32 at
 * (454,4)); GetDItem, GetCIcon(0x100 + record rank +0x22), PlotCIcon in the
 * box sized to the icon bounds, DisposCIcon [PROVEN, bytes]; cicn 256 is
 * named "Ensign" in the dump (rank 0).
 */
void build_rank_and_name_string /* Original: FUN_00001a0e */ (void)

{
  undefined4 uVar1;
  int unaff_A5;
  undefined4 uVar2;
  undefined1 auStack_86 [128];
  short local_6;
  
  local_6 = *(short *)(unaff_A5 + -0x13a4);
  uVar2 = *(undefined4 *)
           (*(short *)(**(int **)(unaff_A5 + -0x13a8) + local_6 * 0x40 + 0x22) * 4 +
           unaff_A5 + -0xffe);
  (**(code **)(unaff_A5 + 0x2fa))(uVar2,uVar2);
  (**(code **)(unaff_A5 + 0x52a))((short)auStack_86,uVar2);
  (**(code **)(unaff_A5 + 0x512))((short)auStack_86,unaff_A5 + -0x2138);
  uVar1 = (**(code **)(unaff_A5 + 0x2fa))(**(int **)(unaff_A5 + -0x13a8) + local_6 * 0x40);
  (**(code **)(unaff_A5 + 0x512))((short)auStack_86,uVar1);
  (**(code **)(unaff_A5 + 0x302))(**(int **)(unaff_A5 + -0x13a8) + local_6 * 0x40);
  (**(code **)(unaff_A5 + 0x302))(uVar2);
  (**(code **)(unaff_A5 + 0x302))(auStack_86);
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00001bc8; source: ID04.c. Recovered name: draw_targets_destroyed_row [STRONG INFERENCE] (iteration 187).
 * Decoded from ID04.bin bytes at file 0x1bc8.
 * C args: +8 DialogPtr, +0xc short item, +0xe short target type (0..9, STR# 129 slots 106-115). Returns at once for types 2 (Tank), 4 (Vehicle) and 8 (PT Boat); otherwise the row index is the type minus the number of skipped types below it (0..6), so seven rows are listed [PROVEN, bytes 0x1bdc..0x1c22]. Saves thePort and its txFont (+0x44), SetPort(dialog), ClipRect(portRect), GetDItem -> box, InsetRect(&box, 4, 0), GetFontInfo ($A88B). Row rect: top = box.top + 23 * row + 3, bottom = top + 16, EraseRect; baseline y = top + ascent; MoveTo(box.left, y).
 * Iteration 188 [PROVEN, bytes 0x1c4a..0x1d9a]: n = counts[type], counts = word array at *A5-0x2226. Label = target name (STR# group A5-0xf86[type]) copied with strcpy (JT $52a); if n != 0, strcat the text at A5-0x2136 and the decimal n (format_int_decimal_pstring, JT $4a2, then ID09 0x432 to a C string); c2p in place (JT $302); TextFont(1) ($A887); DrawString. Points = n * weight[type] (words at A5-0xf5e, the weights used by compute_pilot_score; MULU.L), formatted with JT $4a2 and drawn right-aligned (MoveTo(box.right - StringWidth, y)). Restores txFont and the port.
 * A5-0x2226 points to the local array -0x4a(A6) of show_mission_summary_dialog (set at 0x2e00); the text step adds kills to it (0x2b0c) and to A5-0x13a2 (0x2af8) while the summary runs [PROVEN]. So each row reads "<target> <sep> <n>  ...  <points>" [STRONG INFERENCE for the layout; the separator text at A5-0x2136 is A5 initial data, not yet read].
 * Caller: draw_targets_destroyed_list.
 */
// WARNING: Control flow encountered bad instruction data

void draw_targets_destroyed_row /* Original: FUN_00001bc8 */ (undefined4 param_1,short param_2)

{
  if (((param_2 != 2) && (param_2 != 4)) && (param_2 != 8)) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



/* Original: FUN_00001d9e; source: ID04.c. Recovered name: draw_targets_destroyed_list [PROVEN] (iteration 187).
 * Decoded from ID04.bin bytes at file 0x1d9e.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes): frame_dialog_item_box(dialog, item), then draw_targets_destroyed_row(dialog, item, t) for t = 0..9. Reached through JT $aa (CODE 0 entry -> ID04 0x1d9e); installed for item 6 by show_mission_summary_dialog (0x2e34). Item 6 = DITL 133 dump item 5, box (215,130)-(389,291) under the "Targets Destroyed" label.
 * The following bytes 0x1dde..0x1f5c, inside this Ghidra range and not exported, are draw_mission_awards [STRONG INFERENCE name]: Pascal user item reached through JT $152 (-> ID04 0x1dde), installed for item 5 (dump item 4, (10,130)-(201,200), under "Mission Awards"). frame_dialog_item_box; SetPort; ClipRect(portRect); GetDItem; flags = word +0x26 of the current pilot record; for bit i = 0..7 (flags >>= 1 each step): if set, place a cell in a 3-column grid (x = w * col / 3, y = h * row / 3), GetCIcon(0x200 + i) ($AA1E), PlotCIcon right/bottom-aligned in the cell ($AA1F), DisposCIcon ($AA25) [PROVEN, bytes]. The application has cicn 512..519 (dump). So pilot record +0x26 is an awards bitmask, one bit per award icon [STRONG INFERENCE].
 */
void draw_targets_destroyed_list /* Original: FUN_00001d9e */ (undefined8 param_1)

{
  code *UNRECOVERED_JUMPTABLE;
  undefined2 local_6;
  
  frame_dialog_item_box();
  for (local_6 = 0; local_6 < 10; local_6 = local_6 + 1) {
    draw_targets_destroyed_row(param_1._2_4_,local_6);
  }
                    // WARNING: Could not recover jumptable at 0x00001ddc. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Original: FUN_00001f5e; source: ID04.c. Recovered name: draw_aircraft_kill_markers [STRONG INFERENCE] (iteration 186).
 * Decoded from ID04.bin bytes at file 0x1f5e.
 * C args: +8 DialogPtr, +0xc short item. frame_dialog_item_box(dialog, item); SetPort(dialog); ClipRect(&thePort->portRect) ($A87B); GetDItem -> box (w, h). count = tally[0] + tally[1] of the current pilot record (*A5-0x13a8 + A5-0x13a4 * 0x40 + 0x28; tally 0 / 1 = Fighter / Bomber per STR# 129 slots 106/107 [STRONG INFERENCE]), capped at 24. For i < count, in a 6-column grid (col 0..5, then row++): x = w * col / 6, y = h * row / 4; frames a 26 x 16 rect centred on (x, y) offset by (box.left + 10, box.top + 15) (OffsetRect $A8A8, FrameRect $A8A1); then a 16-wide rect from x + box.left + 7, InsetRect(3, 3), RGBForeColor({0xffff, 0, 0}) ($AA14), PaintOval ($A8B8), ForeColor(33 = blackColor) ($A862). Restores the port [PROVEN, bytes 0x1f5e..0x20e6]. Draws one kill marker (red disc in a frame) per aircraft destroyed [STRONG INFERENCE]. Its item is item 7 of DLOG 133 (DITL dump item 6, 191 x 70 box directly under the "Total Aircraft Destroyed" label) [PROVEN placement]. Ghidra stopped after the first call.
 */
// WARNING: Control flow encountered bad instruction data

void draw_aircraft_kill_markers /* Original: FUN_00001f5e */ (void)

{
  frame_dialog_item_box();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000020e8; source: ID04.c. Recovered name: aircraft_kill_markers_user_item_proc [PROVEN] (iteration 186).
 * Decoded from ID04.bin bytes at file 0x20e8.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes, which Ghidra read as an unrecoverable jump table): calls draw_aircraft_kill_markers(dialog, item). Reached through JT $ea (CODE 0 entry -> ID04 0x20e8); installed for item 7 by show_mission_summary_dialog (pea $ea(A5) at 0x2e5c, set_dialog_user_item_proc at 0x2e68). See the comment after this function for the two unexported routines in the rest of its Ghidra range.
 */
void aircraft_kill_markers_user_item_proc /* Original: FUN_000020e8 */ (void)

{
  code *UNRECOVERED_JUMPTABLE;
  
  draw_aircraft_kill_markers();
                    // WARNING: Could not recover jumptable at 0x00002102. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Iteration 185: bytes 0x2104..0x2d84 lie inside Ghidra's FUN_000020e8 range
 * (Ghidra stopped at the JMP (A0) at 0x2102) and hold two functions that
 * Ghidra did not export. Decoded from ID04.bin; no C was changed.
 *
 * (a) file 0x2104, JT $ca (CODE 0 entry -> ID04 0x2104):
 *     mission_summary_filter_proc [STRONG INFERENCE name]. Pascal ModalDialog
 *     filter: DialogPtr +0x10, EventRecord * +0xc, short *itemHit +8; pops
 *     0xc bytes and returns a Boolean byte [PROVEN]. Passed as pea $ca(A5) at
 *     0x3056 by show_mission_summary_dialog. Switch on event->what through
 *     ID01 helper JT $2a; inline table at 0x2112 = count 3, then
 *     (offset, value) pairs and a default offset, offsets relative to their
 *     own word [PROVEN by instruction boundaries]:
 *       keyDown (3)   -> 0x2122: char = message & 0xff, switch through
 *                        JT $32 (long values): 13 Return / 3 Enter -> 0x2144:
 *                        if the step delay A5-0x2230 is 0, *itemHit = default
 *                        item A5-0x225e and return true;
 *       mouseDown (1) -> 0x2158: click handler 0x1752 on the scrolling text;
 *                        if handled, *itemHit = 8 and return true;
 *       updateEvt (6) -> 0x2178: JT $492 (ID02 0x4d6a) with the event;
 *       default       -> 0x2182.
 *     Timer path 0x2182: if abs_long(TickCount() - A5-0x222c) >= A5-0x2230,
 *     call the text step (b) with (dialog, 8, A5-0x2220); when it returns
 *     non-zero call update_summary_dialog_buttons(dialog, 0); then
 *     A5-0x222c = TickCount(). Returns false.
 *     So A5-0x222c = tick of the last step, A5-0x2230 = delay before the next
 *     step [STRONG INFERENCE], item 8 = the scrolling text item (DITL 133
 *     dump item 7, 476 x 66 box) [STRONG INFERENCE].
 *
 * (b) file 0x21d6..0x2d84: advance_mission_summary_text [STRONG INFERENCE name].
 *     C args +8 DialogPtr, +0xc short item, +0xe short. Switch on the step
 *     state A5-0x2222 through JT $3a; table at 0x21ea = lo 0, hi 5, default
 *     +0xb92 -> 0x2d80 (return 0), cases 0 -> 0x21fc, 1 -> 0x28c2,
 *     2 -> 0x291e, 3 -> 0x2a2e, 4 -> 0x2b74, 5 -> 0x2c4e [PROVEN, bytes].
 *     Appends STR# 129 lines with append_line_to_scrolling_text (e.g. slot 30
 *     "Summary of mission up to the present time.", 31 "You are dead.",
 *     50 "No new kills to report.") and sets A5-0x2222 to the next state
 *     (100 = finished, returns 1 at 0x2d76..0x2d7e). Per-state decoding is
 *     still open.
 */

/* Original: FUN_00002d86; source: ID04.c. Recovered name: set_score_item_text [PROVEN] (iteration 185).
 * C args: +8 DialogPtr, +0xc short item. strcpy (JT $52a = ID02 0x2c8) the
 * STR# 129 slot 58 text "Score: " (A5-0xe5e) into A5-0x2174;
 * format_int_decimal_pstring(compute_pilot_score(current pilot A5-0x13a4),
 * A5-0x2160) (JT $4a2); JT $2fa = ID09 0x432 converts it to a C string;
 * strcat (JT $512 = ID02 0x2d8); JT $302 = ID09 0x416 converts A5-0x2174 to a
 * Pascal string in place; set_dialog_item_text(dialog, item, A5-0x2174).
 * Callers: ID04 0x2b4a (summary text step) and 0x3012
 * (show_mission_summary_dialog). ID02 0x2c8 / 0x2d8 bytes are strcpy /
 * strcat loops; ID09 0x416 shifts bytes right and stores the length
 * [PROVEN, bytes].
 */
void set_score_item_text /* Original: FUN_00002d86 */ (void)

{
  short sVar1;
  int iVar2;
  undefined2 uVar3;
  int unaff_A5;
  undefined4 unaff_A6;
  
  uVar3 = (undefined2)((uint)unaff_A6 >> 0x10);
  sVar1 = (short)unaff_A5;
  (**(code **)(unaff_A5 + 0x52a))(sVar1 + -0x2174,(short)*(undefined4 *)(unaff_A5 + -0xe5e));
  iVar2 = compute_pilot_score(CONCAT22(*(undefined2 *)(unaff_A5 + -0x13a4),uVar3));
  (**(code **)(unaff_A5 + 0x4a2))((short)iVar2,sVar1 + -0x2160);
  uVar3 = (**(code **)(unaff_A5 + 0x2fa))(sVar1 + -0x2160);
  (**(code **)(unaff_A5 + 0x512))(sVar1 + -0x2174,uVar3);
  (**(code **)(unaff_A5 + 0x302))(sVar1 + -0x2174);
  set_dialog_item_text();
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00002de6; source: ID04.c:809.
 * Recovered name: show_mission_summary_dialog [STRONG INFERENCE] (iteration 180).
 * Exported C kept (only the early-out branch survives). Bytes 0x2de6..0x3122
 * [PROVEN, condensed]: A5-0x2226 = local work buffer; if (mode A5-0x12f8 == 2
 * && param == -1) return 1 (no summary); else GetNewDialog(133, ...) $A97C,
 * JT $472 (ID02 0x4582); many item set-up calls through local helpers (0xec,
 * 0x06, 0xc4, 0x54, 0x78, 0x1b8, 0x17e6) and a 12-iteration loop (the 12
 * tallies), list/record work through JT $4ea (ID02 0x232); second arg code 3
 * selects a different path (cmpi #3, $a(A6)).
 * DLOG 133 "Mission Summary" / DITL 133 [PROVEN, resource dump]: buttons
 * "End Mission", "OK", "Skip Text"; custom items; texts "Mission Awards",
 * "Targets Destroyed", "Total Aircraft Destroyed", "Score", "Score: 123456".
 * Called by conclude_mission with (-1, code).
 */
undefined2 show_mission_summary_dialog /* Original: FUN_00002de6 */ (undefined4 param_1)

{
  int unaff_A5;
  undefined1 auStack_4e [74];
  
  *(undefined1 **)(unaff_A5 + -0x2226) = auStack_4e;
  if ((*(short *)(unaff_A5 + -0x12f8) == 2) && (param_1._0_2_ == -1)) {
    *(undefined2 *)(unaff_A5 + -0x13a4) = *(undefined2 *)(unaff_A5 + -0x13a4);
    return 1;
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00003124; source: ID04.c:828.
 * Recovered name: play_named_sound_async [STRONG INFERENCE] (iteration 179).
 * Ghidra truncated after clearing the globals. Bytes 0x3124..0x3176 [PROVEN]:
 *   A5-0x2156 = A5-0x2152 = 0;
 *   h = GetNamedResource('snd ' (0x736e6420), name = Pascal string at
 *       A5-0x2128) $A9A1 -> A5-0x2156; if (!h) return;
 *   HLock(h) (JT $272); SndNewChannel(&chan A5-0x2152, 0, 0x80, nil) $A807;
 *   if (chan) SndPlay(chan, h, true /async/) $A805.
 * Called by conclude_mission (once, when the pilot status is 1 "Dead" and an
 * option is on). [HYPOTHESIS] the name is one of the 'snd ' resources in the
 * dump (e.g. "ugh"); the A5 initial-data string is not yet read.
 */
void play_named_sound_async /* Original: FUN_00003124 */ (void)

{
  int unaff_A5;
  
  *(undefined4 *)(unaff_A5 + -0x2156) = 0;
  *(undefined4 *)(unaff_A5 + -0x2152) = 0;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_00003178; source: ID04.c:843.
 * Recovered name: stop_named_sound [STRONG INFERENCE] (iteration 179).
 * Bytes 0x3178..0x31a8 [PROVEN]: if (chan A5-0x2152) {
 *   SndDisposeChannel(chan, true) $A801; chan = 0 }; if (h A5-0x2156) {
 *   HUnlock(h) (JT $27a); ReleaseResource(h) $A9A3; h = 0 }.
 * Inverse of play_named_sound_async; called by conclude_mission.
 */
void stop_named_sound /* Original: FUN_00003178 */ (void)

{
  int unaff_A5;
  
  if (*(int *)(unaff_A5 + -0x2152) != 0) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  if (*(int *)(unaff_A5 + -0x2156) != 0) {
    (**(code **)(unaff_A5 + 0x27a))((short)*(undefined4 *)(unaff_A5 + -0x2156));
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return;
}



// WARNING: Control flow encountered bad instruction data

/*
 * Original: FUN_000031aa; source: ID04.c:864.
 * Recovered name: conclude_mission [STRONG INFERENCE] (iteration 178).
 * Exported C kept (truncated after the status write). JT $da; callers
 * [PROVEN, bytes]: ID02 file 0x8cc and 0x3752 (do_menu_command menu 2 item 5,
 * which passes code 3 and long A5-0xd6a).
 * Args: word code (param_1 high), long (second arg).
 *   if (mode A5-0x12f8 != 2 && status A5-0x12b4 == 1 && code != 3 &&
 *       first time (A5-0x14c2 == 0, then set to 1) && option A5-0x12ee)
 *     play_named_sound_async() (FUN_00003124);
 *   if (code != 3 && status != 0) A5-0x14c4 = 1;   ("mission over": makes
 *       confirm_end_mission return 2 without asking)
 *   r = show_mission_summary_dialog (FUN_00002de6)(-1, code); if (option A5-0x12ee) stop_named_sound() (FUN_00003178);
 *   current pilot record (A5-0x13a4) +0x20 = status if it changed ... [rest
 *   truncated by Ghidra].
 * Status values follow the A5-0xfae strings (0 Active, 1 Dead, 2 Retired,
 * 3 POW, 4 Discharged, 5 MIA) [STRONG INFERENCE: status 1 triggers the
 * special one-shot path].
 */
undefined4 conclude_mission /* Original: FUN_000031aa */ (undefined4 param_1)

{
  int iVar1;
  undefined2 uVar2;
  int unaff_A5;
  
  if ((((*(short *)(unaff_A5 + -0x12f8) != 2) && (*(short *)(unaff_A5 + -0x12b4) == 1)) &&
      (param_1._0_2_ != 3)) &&
     ((*(short *)(unaff_A5 + -0x14c2) == 0 &&
      (*(undefined2 *)(unaff_A5 + -0x14c2) = 1, *(short *)(unaff_A5 + -0x12ee) != 0)))) {
    play_named_sound_async();
  }
  if ((param_1._0_2_ != 3) && (*(short *)(unaff_A5 + -0x12b4) != 0)) {
    *(undefined2 *)(unaff_A5 + -0x14c4) = 1;
  }
  uVar2 = show_mission_summary_dialog(CONCAT22(0xffff,param_1._0_2_));
  if (*(short *)(unaff_A5 + -0x12ee) != 0) {
    stop_named_sound();
  }
  iVar1 = **(int **)(unaff_A5 + -0x13a8) + *(short *)(unaff_A5 + -0x13a4) * 0x40;
  if (*(short *)(iVar1 + 0x20) != *(short *)(unaff_A5 + -0x12b4)) {
    *(undefined2 *)(**(int **)(unaff_A5 + -0x13a8) + *(short *)(unaff_A5 + -0x13a4) * 0x40 + 0x20) =
         *(undefined2 *)(unaff_A5 + -0x12b4);
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
  return CONCAT22((short)((uint)iVar1 >> 0x10),uVar2);
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003260(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003352(void)

{
  if (*(short *)(DAT_00000904 + -0x214e) == 0) {
    FUN_00003260();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_000033d6(void)

{
  int unaff_A5;
  
  *(undefined2 *)(unaff_A5 + -0x214e) = 0;
  frame_dialog_item_box();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



void FUN_000035f8(void)

{
  code *UNRECOVERED_JUMPTABLE;
  
  FUN_000033d6();
                    // WARNING: Could not recover jumptable at 0x00003612. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003902(void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x2a))();
  (**(code **)(unaff_A5 + 0x32))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003a56(void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



// WARNING: Control flow encountered bad instruction data

void FUN_00003a8c(void)

{
  int unaff_A5;
  
  if (*(short *)(unaff_A5 + -0x137a) == 1) {
                    // WARNING: Bad instruction - Truncating control flow here
    halt_baddata();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/*
 * Original: FUN_00003d42; source: ID04.c:993.
 * Recovered name: check_system_requirements [STRONG INFERENCE] (iteration 172).
 * Exported C complete; bytes 0x3d42..0x3d78 agree (last function of ID04).
 * JT $f2, called by ID02 initialize_application (returns 0 -> ExitToShell).
 *   SysEnvirons(1, &env) (JT $1f2 = ID09 sysenvirons dispatcher);
 *   if (!env.hasColorQD (env+9) || env.processor (env+6) < 3 /env68020/) {
 *     show_caution_alert_with_number(STR# 129 slot 61, 0) (JT $4ba; slot 61 =
 *       "Hellcats requires a Macintosh with color QuickDraw and a 68020 or
 *       higher" [PROVEN, resource dump]); return 0; }
 *   return 1.
 * Explains the 68020-only instructions (EXTB.L, MULU.L, DIVS.L) used elsewhere.
 */
undefined4 check_system_requirements /* Original: FUN_00003d42 */ (void)

{
  undefined4 uVar1;
  int unaff_A5;
  undefined1 auStack_14 [6];
  short local_e;
  char local_b;
  
  (**(code **)(unaff_A5 + 0x1f2))(auStack_14,0);
  if ((local_b == '\0') || (local_e < 3)) {
    (**(code **)(unaff_A5 + 0x4ba))(*(undefined4 *)(unaff_A5 + -0xe52));
    uVar1 = 0;
  }
  else {
    uVar1 = 1;
  }
  return uVar1;
}


