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



/* Original: FUN_00000220; source: ID04.c. Recovered name: draw_percent_bar_item [PROVEN] (iteration 193).
 * Decoded from ID04.bin bytes at file 0x220.
 * C args: +8 DialogPtr, +0xc short item. GetDItem -> box; split = box.left + width * A5-0x225c / 100 (MULU.L / DIVS.L); FillRect(left part, dkGray A5-0x1634) ($A8A5), FillRect(right part from split + 1, white A5-0x1614); InsetRect(&box, -1, -1), PenSize(1, 1), FrameRect. A5-0x225c is a 0..100 value set by mouse tracking at 0xb3c..0xb9a (100 * (mouse - left) / width, clamped) and copied to/from settings word +0x22 of the handle A5-0x13ac and the live option A5-0x12d2 [PROVEN]. So this draws a percentage slider in the settings dialog [STRONG INFERENCE; which option it controls is open]. Callers: percent_bar_user_item_proc, 0xb9a.
 */
// WARNING: Control flow encountered bad instruction data

void draw_percent_bar_item /* Original: FUN_00000220 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000002c0; source: ID04.c. Recovered name: percent_bar_user_item_proc [PROVEN] (iteration 193).
 * Decoded from ID04.bin bytes at file 0x2c0.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes, which Ghidra read as an unrecoverable jump table): calls draw_percent_bar_item. Reached through JT $8a (CODE 0 entry -> ID04 0x2c0).
 * The following bytes 0x2dc..0x360 (not exported by Ghidra) are set_radio_group_selection [PROVEN, bytes]: C args +8 DialogPtr, +0xc short *items, +0x10 short count, +0x12 short selected. If items[0] <= selected <= items[count - 1], for each item: GetDItem, SetCtlValue(handle, item == selected) ($A963; SEQ/NEG gives 1 or 0). Callers: 0xcc4, 0xcdc, 0xd2c, 0xd44, 0xeda, 0xf0a.
 */
void percent_bar_user_item_proc /* Original: FUN_000002c0 */ (void)

{
  code *UNRECOVERED_JUMPTABLE;
  
  draw_percent_bar_item();
                    // WARNING: Could not recover jumptable at 0x000002da. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Original: FUN_00000362; source: ID04.c. Recovered name: get_radio_group_selection [PROVEN] (iteration 193).
 * Decoded from ID04.bin bytes at file 0x362.
 * C args: +8 DialogPtr, +0xc short *items, +0x10 short count. Returns the first items[i] whose control value (GetCtlValue $A960) is non-zero, or -1 when none is set (and when count < 1, the case Ghidra decoded) [PROVEN, bytes 0x362..0x3c0]. Pairs with set_radio_group_selection (0x2dc). Callers: 0xd5a, 0xda2, 0xf20.
 */
// WARNING: Control flow encountered bad instruction data

undefined4 get_radio_group_selection /* Original: FUN_00000362 */ (undefined4 param_1,undefined4 param_2,undefined4 param_3)

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



/* Original: FUN_0000044e; source: ID04.c. Recovered name: show_scenery_open_error_alert [PROVEN] (iteration 198).
 * Decoded from ID04.bin bytes at file 0x44e.
 * C arg +8: Pascal string (file name). ParamText(name, NULL, NULL, NULL) ($A98B); JT $47a(0x100) (ID02 0x442e, also called before ALRT 259 by confirm_end_mission); returns StopAlert(256, NULL) ($A986). ALRT 256 is "Unable to Open Scenery": DITL 256 text "Unable to open Hellcats scenery file '^0'." with an OK button. Reached through JT $fa (CODE 0 entry -> ID04 0x44e).
 */
// WARNING: Control flow encountered bad instruction data

void show_scenery_open_error_alert /* Original: FUN_0000044e */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00000478; source: ID04.c. Recovered name: show_paused_dialog [PROVEN] (iteration 198).
 * Decoded from ID04.bin bytes at file 0x478.
 * GetNewDialog(0x83 = DLOG 131 "Paused Dialog", NULL, (WindowPtr)-1) ($A97C); JT $48a (ID02 0x435e); ShowWindow; DrawDialog ($A981); then polls GetNextEvent(0x18 = keyDown | keyUp mask) ($A970) until it has seen a keyDown (what 3) followed by a keyUp (what 4); DisposDialog. DITL 131 text: "Paused ... Press any key to continue." Reached through JT $122 (-> ID04 0x478).
 */
// WARNING: Control flow encountered bad instruction data

void show_paused_dialog /* Original: FUN_00000478 */ (void)

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



/* Original: FUN_000005e4; source: ID04.c. Recovered name: duty_roster_filter_proc [PROVEN] (iteration 198).
 * Decoded from ID04.bin bytes at file 0x5e4.
 * Pascal ModalDialog filter (DialogPtr +0x10, EventRecord * +0xc, itemHit * +8; pops 0xc bytes, Boolean result). Switch on event->what through JT $2a (table at 0x5f2: keyDown 3 -> 0x5fe, updateEvt 6 -> 0x62c, default -> 0x636): keyDown Return (13) / Enter (3) -> *itemHit = 1, return true; updateEvt -> JT $492 (ID02 0x4d6a), false. Reached through JT $c2 (-> ID04 0x5e4).
 * The following bytes 0x644..0x9ec (not exported by Ghidra) are run_duty_roster_dialog [STRONG INFERENCE name], JT $132 (-> ID04 0x644) [PROVEN, bytes]: GetNewDialog(0x82 = DLOG 130 "Duty Roster"); JT $472; rank_pilots_by_score(scores, order); prune_inactive_pilots_beyond_ten(order); for up to ten pilots in score order whose status +0x20 == 0 (Active), row r: SetIText item 5 + r = rank name (A5-0xffe[record +0x22]), item 15 + r = pilot name (editable), item 25 + r = decimal compute_pilot_score; row -> pilot map in a local array. Current pilot = settings +0x20 (A5-0x13ac) -> A5-0x13a4; the row whose pilot equals it (and whose name is set or score non-zero) gets SelIText(item 15 + r, 0, 1000) ($A97E). Default ring on user item 2 (default 1), grey user item 39 (JT $142); ShowWindow; loop ModalDialog(JT $c2): item 3 Cancel -> DisposDialog, return 0; item 4 "Dossier..." -> show_mission_summary_dialog(pilot of the active edit field (dialog->editField + 1 - 15 = row), 0, STR# 63 "OK") - shows that pilot's summary; item 1 OK: for each row GetIText ($A990), p2c both names (ID09 0x432), compare 30 bytes (JT $502, ID02 0x434) and copy when different (JT $50a, ID02 0x3f6), c2p; if any name changed, ChangedResource + WriteResource (roster); A5-0x13a4 = pilot of the active edit field; DisposDialog; return 1.
 */
// WARNING: Control flow encountered bad instruction data

void duty_roster_filter_proc /* Original: FUN_000005e4 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x2a))();
  (**(code **)(unaff_A5 + 0x32))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000009ee; source: ID04.c. Recovered name: draw_select_mission_title [PROVEN] (iteration 197).
 * Decoded from ID04.bin bytes at file 0x9ee.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes). Text = STR# 129 slot 64 "Select a Mission" (pointer A5-0xe46, kept as a Pascal string by the loader). GetDItem -> box; TextSize(24) ($A88A); w = StringWidth ($A88C); GetFontInfo ($A88B); MoveTo(box.left + width / 2 - w / 2, box.top + height / 2 + ascent / 2) ($A893); DrawString ($A884); TextSize(0). Reached through JT $11a (CODE 0 entry -> ID04 0x9ee), installed for item 4 of DLOG 129 "Scenario Selection" by run_scenario_selection_dialog (0xc66).
 */
// WARNING: Control flow encountered bad instruction data

void draw_select_mission_title /* Original: FUN_000009ee */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00000a8e; source: ID04.c. Recovered name: fuel_slider_dialog_filter [STRONG INFERENCE] (iteration 194).
 * Decoded from ID04.bin bytes at file 0xa8e.
 * C args: +8 DialogPtr, +0xc EventRecord *, +0x10 short *itemHit, +0x14 short slider item; returns 1 when the event is handled. Switch on event->what through JT $2a (sparse table at 0xa9c: keyDown 3 -> 0xaac, mouseDown 1 -> 0xae8, updateEvt 6 -> 0xbca, default -> 0xbd4) [PROVEN]: keyDown Return (13) / Enter (3) -> *itemHit = 1, return 1 (the case Ghidra decoded); mouseDown -> GetDItem(slider), SetPort, GlobalToLocal(where), PtInRect ($A8AD); if inside, while StillDown ($A973): GetMouse ($A972), value = 100 * (h - left) / (right - left) clamped to 0..100, and when it changes A5-0x225c = value and draw_percent_bar_item(dialog, slider); then *itemHit = slider, return 1; updateEvt -> JT $492 (ID02 0x4d6a), return 0. The slider is the fuel bar of DLOG 129 "Scenario Selection" and DLOG 132 "Refuel" (labels "Fuel:" "E" "F" in DITL 132), so A5-0x225c = fuel load percentage [STRONG INFERENCE].
 */
undefined4 fuel_slider_dialog_filter /* Original: FUN_00000a8e */ (undefined4 param_1,int param_2,undefined2 *param_3)

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



/* Original: FUN_00000bda; source: ID04.c. Recovered name: scenario_selection_filter_proc [PROVEN] (iteration 194).
 * Decoded from ID04.bin bytes at file 0xbda.
 * Pascal ModalDialog filter (DialogPtr +0x10, EventRecord * +0xc, itemHit * +8; pops 0xc bytes and returns a Boolean byte, which Ghidra read as an unrecoverable jump table): fuel_slider_dialog_filter(dialog, event, itemHit, 5). Reached through JT $112 (CODE 0 entry -> ID04 0xbda), passed at 0xcea by the code that runs GetNewDialog(0x81 = DLOG 129 "Scenario Selection", call at 0xc38), whose item 5 (dump item 4) is the percent bar (JT $8a installed at 0xc8e).
 * Iteration 196: the following bytes 0xc02..0xe46 (not exported by Ghidra)
 * are run_scenario_selection_dialog [STRONG INFERENCE name], reached
 * through JT $82 (CODE 0 entry -> ID04 0xc02); returns the chosen mission
 * number, or 0 on Cancel [PROVEN, bytes]:
 *   mission = settings word +0x1e (handle A5-0x13ac), 0 -> 1; fuel
 *   A5-0x12d2, 0 -> 100; A5-0x225c = fuel;
 *   dialog = GetNewDialog(0x81 = DLOG 129, NULL, (WindowPtr)-1); JT $472;
 *   0x1b8(dialog, 2, 1) default ring on user item 2, default item 1;
 *   user items: 4 -> JT $11a (ID04 0x9ee, FUN_000009ee), 19 -> JT $142
 *   draw_grey_user_item, 5 -> JT $8a fuel bar;
 *   mission 1 -> 2; set_radio_group_selection(dialog, A5-0x2256, 8,
 *   mission + 7); set_radio_group_selection(dialog, A5-0x2246, 3, 8);
 *   ShowWindow; loop ModalDialog(JT $112 scenario_selection_filter_proc):
 *     item 3 (Cancel) -> DisposDialog, return 0;
 *     item 1 (OK) -> confirm_end_mission() (0x516); leave the loop only
 *       when it returns 2;
 *     other items -> set both radio groups to the item;
 *   bombs: sel(A5-0x2246) - 6 -> settings +0x24; mission: sel(A5-0x2256) - 7
 *   -> settings +0x1e; fuel A5-0x225c -> settings +0x22; current pilot
 *   A5-0x13a4 -> settings +0x20; each change sets A5-0x138a (settings
 *   dirty);
 *   DisposDialog; JT $4ca apply_settings_to_live_options (ID02 0x2a44);
 *   A5-0x14c4 (mission over) = 0; A5-0x12f8 = settings +0x1e; JT $4c2
 *   (ID02 0x212a, FUN_0000212a); return A5-0x12f8.
 * DITL 129 radio items 9..16 (dump 8..15) are "Flight School", "Bomb Base",
 * "Capture Island", "Flying Fortress", "Scramble!", "Divine Wind",
 * "Flattop", "The Duel", so mission numbers 2..9 map to them in that order
 * (item - 7) [PROVEN mapping arithmetic; STRONG INFERENCE that the A5-0x2256
 * list holds items 9..16]. This matches the summary: mission 2 (Flight
 * School) reports no kills, 5 Flying Fortress -> "The B17 has been
 * destroyed", 6 Scramble! -> Henderson field bombed. Bomb radio items 6..8
 * = "0", "1", "2" (bombs = item - 6).
 */
void scenario_selection_filter_proc /* Original: FUN_00000bda */ (undefined2 *param_1,int param_2,undefined4 param_3)

{
  undefined4 uVar1;
  code *UNRECOVERED_JUMPTABLE;
  undefined1 uStack00000010;
  
  uVar1 = fuel_slider_dialog_filter(param_3,param_2,param_1);
  uStack00000010 = (undefined1)uVar1;
                    // WARNING: Could not recover jumptable at 0x00000c00. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Original: FUN_00000e48; source: ID04.c. Recovered name: refuel_dialog_filter_proc [PROVEN] (iteration 194).
 * Decoded from ID04.bin bytes at file 0xe48.
 * Pascal ModalDialog filter, as scenario_selection_filter_proc but with slider item 3: fuel_slider_dialog_filter(dialog, event, itemHit, 3). Reached through JT $14a (-> ID04 0xe48), passed at 0xee8 by the code that runs GetNewDialog(0x84 = DLOG 132 "Refuel", 0xe88..0xe92); item 3 (dump item 2) is the fuel bar, radio buttons "0" "1" "2" next to "Bombs:" [PROVEN placement].
 * Iteration 195: the following bytes 0xe70..0xf4c (not exported by Ghidra)
 * are run_refuel_dialog [STRONG INFERENCE name], reached through JT $9a
 * (CODE 0 entry -> ID04 0xe70) [PROVEN, bytes]:
 *   saves A5-0x12f8 and A5-0x12d0 in locals (never read again);
 *   A5-0x225c = fuel A5-0x12d2;
 *   dialog = GetNewDialog(0x84, NULL, (WindowPtr)-1) ($A97C);
 *   JT $472 (ID02 0x4582, also called by show_mission_summary_dialog);
 *   0x1b8(dialog, 2, 1): the default-button ring installer (user item 2,
 *     default item 1 into A5-0x225e);
 *   set_dialog_user_item_proc(dialog, 3, JT $8a percent_bar_user_item_proc);
 *   set_radio_group_selection(dialog, A5-0x2240 item list, 3, 6) - always
 *     starts with item 6 (bombs "2") selected, not with the saved count;
 *   ShowWindow ($A915);
 *   loop: ModalDialog(JT $14a refuel_dialog_filter_proc, &item) ($A991);
 *     until item == 1 (OK): set_radio_group_selection(dialog, list, 3, item)
 *     (slider hits, item 3, fall outside the radio range and do nothing);
 *   sel = get_radio_group_selection(dialog, list, 3); if sel != -1:
 *     A5-0x12d0 = sel - 4 (0..2 bombs);
 *   A5-0x12d2 = A5-0x225c (fuel %); DisposDialog ($A983).
 * So A5-0x12d2 = fuel load percentage and A5-0x12d0 = bomb count for the
 * flight, and A5-0x2240 holds the bomb radio items 4, 5, 6 [STRONG
 * INFERENCE; the list contents are A5 initial data].
 */
void refuel_dialog_filter_proc /* Original: FUN_00000e48 */ (undefined2 *param_1,int param_2,undefined4 param_3)

{
  undefined4 uVar1;
  code *UNRECOVERED_JUMPTABLE;
  undefined1 uStack00000010;
  
  uVar1 = fuel_slider_dialog_filter(param_3,param_2,param_1);
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



/* Original: FUN_0000116a; source: ID04.c. Recovered name: prune_inactive_pilots_beyond_ten [STRONG INFERENCE] (iteration 197).
 * Decoded from ID04.bin bytes at file 0x116a.
 * Arg +8: short order[20] (pilot indices sorted by rank_pilots_by_score). HLock(roster A5-0x13a8) (JT $272); walks order[0..19]; for each record whose status +0x20 != 0 (not Active), counts it, and every such record after the first ten is cleared with reset_pilot_record; HUnlock (JT $27a); if anything was cleared, ChangedResource ($A9AA) and WriteResource ($A9B0) on the roster [PROVEN, bytes 0x116a..0x11fe]. So the roster keeps at most ten retired / dead / POW / discharged / MIA pilots, the best scores first. Caller: ID04 0x678, right after rank_pilots_by_score at 0x66e. Ghidra stopped before the resource calls.
 */
// WARNING: Control flow encountered bad instruction data

void prune_inactive_pilots_beyond_ten /* Original: FUN_0000116a */ (int param_1)

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



/* Original: FUN_00001200; source: ID04.c. Recovered name: draw_high_scores_table [PROVEN] (iteration 201).
 * Decoded from ID04.bin bytes at file 0x1200.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes). rank_pilots_by_score(scores, order); GetDItem -> box, EraseRect; column x = left edge of items 4..7 (DITL 134 labels "Rank", "Name", "Status", "Score"); HLock(roster) (JT $272); GetFontInfo; for pilots in score order whose name is set or whose score is non-zero, at most ten rows 20 pixels apart (baseline box.top + ascent + 20 * row): DrawString of the rank name (A5-0xffe[record +0x22]), the pilot name (record +0), the status name (A5-0xfae[record +0x20]) and the decimal score (JT $4a2); HUnlock (JT $27a) [PROVEN, bytes 0x1200..0x1378]. Reached through JT $e2 (CODE 0 entry -> ID04 0x1200); installed for item 10 of DLOG 134 "High Scores". Ghidra stopped after the first call.
 * The following bytes 0x137a..0x149e (not exported by Ghidra) are run_high_scores_dialog [STRONG INFERENCE name], JT $102 (-> ID04 0x137a) [PROVEN, bytes]: GetNewDialog(0x86 = DLOG 134); JT $472; 0x1b8(dialog, 2, 1) default ring; grey user item 8 (JT $142); item 10 = this table (JT $e2); ShowWindow; loop ModalDialog(NULL): item 3 "Erase Nonactive..." -> if confirm_erase_high_scores() == 2: reset_pilot_record for every record whose status +0x20 != 0 (roster locked meanwhile); if any was cleared, ChangedResource + WriteResource and InvalRect(item 10) so the table redraws; until item 1 (OK); DisposDialog.
 */
// WARNING: Control flow encountered bad instruction data

void draw_high_scores_table /* Original: FUN_00001200 */ (void)

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
 *
 *     Iteration 189 - state 3, 0x2a2e..0x2b70 ("kill transfer") [PROVEN, bytes]:
 *     the index A5-0x2176 skips target types whose mission kill count
 *     A5-0x12ce[t] is 0. When it reaches 10: ChangedResource(A5-0x13a8 roster
 *     handle, HEL1 128) ($A9AA), UpdateResFile(A5-0x1002) ($A999), state = 4,
 *     line cursor A5-0x21ca = &A5-0x21c6. Otherwise, for type t with n kills:
 *       line = decimal n (JT $4a2, ID09 0x432) + text A5-0x212e + target name
 *              A5-0xf86[t], plus text A5-0x212c when n > 1 [STRONG INFERENCE:
 *              a space and a plural "s"; A5 initial data not read];
 *       pilot record tally[t] (+0x28 + 2t) += n; A5-0x12ce[t] = 0;
 *       A5-0x13a2[t] += n; summary counts (*A5-0x2226)[t] += n;
 *       append_line_to_scrolling_text(line); set_score_item_text(dialog, 14);
 *       draw_targets_destroyed_row(dialog, 6, t);
 *       draw_aircraft_kill_markers(dialog, 7); return 0.
 *     So pilot tallies 0..9 are lifetime kills per target type and A5-0x12ce
 *     holds the kills of the current mission not yet added [PROVEN].
 *
 *     Iteration 190 - state 4, 0x2b74..0x2c4c ("promotion check") [PROVEN, bytes]:
 *     score = compute_pilot_score(A5-0x13a4); thresholds = longs at A5-0xfd6
 *     indexed by rank. If score < threshold[rank + 1]: state = 100, return 1
 *     (summary finished). Otherwise queue STR# lines through the cursor
 *     A5-0x21ca into the pointer queue at A5-0x21c6: slot 53 "Its not all bad
 *     news though, you gained enough points to advance in rank!" when the
 *     pilot status A5-0x12b4 == 1 (Dead), else slots 54 "Congratulations!" and
 *     55 "You have gained enough points to advance in rank!"; new rank = the
 *     last index with threshold <= score, stored in record +0x22;
 *     ChangedResource(roster) + UpdateResFile(A5-0x1002); A5-0x2176 = number
 *     of queued lines; cursor reset; state = 5; return 0.
 *     So A5-0xfd6 = rank point thresholds (one long per rank) [STRONG
 *     INFERENCE; values are A5 initial data].
 *
 *     State 5, 0x2c4e..0x2d7e ("promotion text"): while A5-0x2176-- != 0,
 *     append the next queued line and return 0. Then line = slot 56 "You are
 *     posthumously promoted to the grade of " (Dead) or slot 57 "You are
 *     promoted to the grade of ", + new rank name (A5-0xffe[rank]) + text
 *     A5-0x212a [STRONG INFERENCE: a full stop]; append it; SetPort(dialog);
 *     for item 15 (rank insignia; InsetRect(-36, -4)) and item 9 (rank and
 *     name title; InsetRect(-4, -4)) GetDItem, EraseRect, InvalRect so both
 *     redraw with the new rank; restore the port; state = 100; return 1.
 *
 *     Iteration 191 - state 1, 0x28c2..0x291c [PROVEN, bytes]: while
 *     A5-0x2176-- != 0, append the next queued line (cursor A5-0x21ca) and
 *     return 0. Then, if A5-0x2228 == -1: state = 2; otherwise append STR#
 *     slot 49 "Player's Cumulative History", state = 100, return 1.
 *
 *     State 2, 0x291e..0x2a28 [PROVEN, bytes]: append the text at A5-0x2130
 *     [STRONG INFERENCE: an empty line]. If (arg +0xe & 0xff) == 1 and the
 *     pilot status A5-0x12b4 != 1 (not Dead): record +0x26 |= 1 << (A5-0x12f8
 *     - 3), ChangedResource(roster) + UpdateResFile(A5-0x1002), then
 *     erase / invalidate item 5 (mission awards) so it redraws. So award bit
 *     n is earned by succeeding in mission A5-0x12f8 = n + 3, and the eight
 *     award icons (cicn 512..519) are one per mission [STRONG INFERENCE].
 *     arg +0xe is A5-0x2220, the word argument that conclude_mission passes
 *     to show_mission_summary_dialog (stored at 0x302c) [PROVEN]; its low
 *     byte == 1 means "mission accomplished" [HYPOTHESIS].
 *     Then k = get_mission_kill_report_state(): if k == 0, append slot 50
 *     "No new kills to report.", state = 100, return 1 (the following test
 *     of the same k that would select state 4 is never true - unreachable in
 *     the original bytes 0x29d8..0x29f0); otherwise append slots 51 "Now
 *     adding points to permanent score" and 52 "==== Kills ====", state = 3,
 *     A5-0x2176 = 0, return 0.
 *
 *     Iteration 192 - state 0, 0x21fc..0x28c0 ("outcome narrative") [PROVEN
 *     control flow, bytes; texts from the STR# 129 dump]. Lines are queued
 *     through the cursor A5-0x21ca (reset to &A5-0x21c6) and printed by
 *     state 1. "slot n" = STR# 129 slot; the pointer group A5-0x221e + 4k
 *     (ID07 init_string_pointer_groups) is slot 2 + k.
 *     Outcome code = arg +0xe & 0xff (low byte of A5-0x2220), switch through
 *     JT $3a, table at 0x2210: lo 1, hi 10, default -> 0x272e:
 *       1 (0x222a) flight ended [meaning HYPOTHESIS]: if pilot status A5-0x12b4 == 1: slot 23 (bailed
 *         out without enough altitude) when A5-0x12b2 != 0, else slot 24
 *         "POW!" and one of slots 25..28 chosen by (TickCount() >> 2) & 3
 *         (JT $32 table at 0x2268); otherwise slot 29 (objectives achieved,
 *         mission complete);
 *       3 (0x2620) mission in progress: prints slot 30 directly, then slot
 *         31 "You are dead." (status 1), 32 (unbanked points) when
 *         get_mission_kill_report_state() == 1, or 33 (objectives done,
 *         return to base) when it is 2; if A5-0x14c0 == 0: A5-0x12ba == -1
 *         -> failure line by mission A5-0x12f8 (table at 0x26b4: 5 -> slot 34
 *         B17, 6 -> 35 Henderson field, 7 and 9 -> 36 carrier, 8 -> none),
 *         A5-0x12ba == -2 -> slot 37 (original Hellcat lost); state = 100,
 *         return 1 (no queue);
 *       6 (0x22d4) ditching (slot 2), 7 (0x23c6) bail-out (slot 21),
 *         8 (0x24f2) disabled-aircraft landing (slot 3), 9 (0x25b8) landing
 *         (slot 6), 10 (0x24b8) landing at an enemy base (slots 4, 5, 16, 17):
 *         these set the local "aircraft lost" flag -0x48 (except 9) and add
 *         location / rescue lines selected by the flag bits of arg +0xe
 *         (high byte: bit 1 -> slot 12 friendly territory; else bit 0 ->
 *         slot 10 enemy territory, else slot 11) and by the status
 *         A5-0x12b4 (sub-switches at 0x233a, 0x2398, 0x242c, 0x248a, 0x2534,
 *         0x2588: slots 13..20). Status 4 (Discharged) after an undamaged
 *         ditch / bail-out adds slots 7 or 22 and 8;
 *       2, 4, 5 (default 0x272e): no outcome text (local -0x46 = 1).
 *     Friendly fire, 0x2734 (only when -0x46 == 0, status Active and the
 *     friendly-kill count A5-0x12b6 != 0): slot 9; if A5-0x12b6 >= 5: slots
 *     38, 39 (treason, executed), status = 1 (Dead), A5-0x14c4 = 1; else
 *     record +0x24 += 1 (saved with ChangedResource / UpdateResFile) and by
 *     its new value 1 -> slots 40, 41, 2 -> slots 42, 43, 3 -> slots 44, 8
 *     with status = 4 (Discharged), A5-0x14c4 = 1; then A5-0x12b6 = 0.
 *     Lost aircraft, 0x2828 (flag -0x48, A5-0x14c0 == 0, status Active): if
 *     A5-0x12ba > 0 queue A5-0x2134 and slots 45, 46; if == 0 queue A5-0x2132
 *     and slots 47, 48; then A5-0x12ba = -2.
 *     Finally A5-0x2176 = number of queued lines, cursor reset, state = 1,
 *     return 0.
 *     So: record +0x24 = friendly-fire offence count, A5-0x12b6 = friendly
 *     units destroyed this mission, A5-0x12ba = objective state (> 0 done,
 *     0 open, -1 failed by mission event, -2 original Hellcat lost)
 *     [STRONG INFERENCE from the texts]. Note slot 45 "By losing your
 *     airplane..." is queued when A5-0x12ba > 0 and slot 47 "By losing your
 *     original hellcat..." when it is 0, as the bytes say.
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



/* Original: FUN_00003260; source: ID04.c. Recovered name: draw_map_grid_and_centre_mark [PROVEN] (iteration 199).
 * Decoded from ID04.bin bytes at file 0x3260.
 * No arguments. SetOrigin(A5-0x2148, A5-0x2146) ($A878); OffsetRect(map rect A5-0x2144, width/2, height/2) ($A8A8) and ClipRect ($A87B); ForeColor 30 (whiteColor) when A5-0x137a == 1, else 33 (blackColor) ($A862); PenSize(1, 1); for i = 1..3 MoveTo / Line ($A893 / $A892) a vertical line at x = i * w / 4 and a horizontal line at y = i * h / 4 (w, h = A5-0x214c, A5-0x214a): a 4 x 4 grid; then PenSize(3, 3) and a small cross at the centre (Move / Line, $A894 / $A892); A5-0x214e = 1 (grid drawn). Callers: plot_map_symbol_callback (0x3368), draw_map_view_item (0x350a).
 */
// WARNING: Control flow encountered bad instruction data

void draw_map_grid_and_centre_mark /* Original: FUN_00003260 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00003352; source: ID04.c. Recovered name: plot_map_symbol_callback [PROVEN] (iteration 199).
 * Decoded from ID04.bin bytes at file 0x3352.
 * C-callable callback reached through JT $72 (CODE 0 entry -> ID04 0x3352), passed by draw_map_view_item to the function pointer A5-0x1052 (pea $72(A5) at 0x34f6). Saves A5 and D2, loads A5 from CurrentA5 ($0904). If A5-0x214e == 0 draws the grid first (draw_map_grid_and_centre_mark). Args: +0xb char symbol, +0xc long x, +0x10 long y; x and y are shifted from centre-relative to origin-relative coordinates (x - (A5-0x2148 - w/2) + A5-0x2148 ...); ForeColor 30 (whiteColor); MoveTo(x, y); DrawChar(symbol) ($A883, EXTB.L on the byte). Draws one map marker character per object [STRONG INFERENCE].
 */
// WARNING: Control flow encountered bad instruction data

void plot_map_symbol_callback /* Original: FUN_00003352 */ (void)

{
  if (*(short *)(DAT_00000904 + -0x214e) == 0) {
    draw_map_grid_and_centre_mark();
  }
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000033d6; source: ID04.c. Recovered name: draw_map_view_item [STRONG INFERENCE] (iteration 199).
 * Decoded from ID04.bin bytes at file 0x33d6.
 * C args: +8 DialogPtr, +0xc short item. Saves thePort; A5-0x214e = 0; frame_dialog_item_box; SetPort(dialog); GetDItem -> A5-0x2144 (map rect); SetOrigin(-left, -top) and OffsetRect so the rect starts at 0, 0; A5-0x214c / -0x214a = width / height. Background: if A5-0x137a == 1, FillRect with the pattern / colour returned by JT $1ca (ID06 file 0x116) for local {-1, 0, 0}; else ForeColor 409 (blueColor) and PaintRect ($A8A2) - a blue sea. SetOrigin to the centre, ClipRect. Calls the function pointer A5-0x1052(scale, JT $72 plot_map_symbol_callback) with scale = settings +0x26 * 4 * 0xce40 / width (MULU.L / DIVS.L) - the plotting itself lives elsewhere (A5-0x1052 is set outside ID04) [PROVEN call; HYPOTHESIS: the overlay walks the world objects]. Draws the grid if the callback did not; ForeColor(black); PenSize(2, 2) and a short polyline near the top-right corner (a north arrow?) [HYPOTHESIS]; restores pen, origin, clip and port; item 7 text = decimal settings +0x26 + STR# 129 slot 59 " mi./grid" via set_dialog_item_text. So settings +0x26 = map scale in miles per grid square [STRONG INFERENCE]. Callers: 0x3604, 0x3a10, 0x3a3e.
 */
// WARNING: Control flow encountered bad instruction data

void draw_map_view_item /* Original: FUN_000033d6 */ (void)

{
  int unaff_A5;
  
  *(undefined2 *)(unaff_A5 + -0x214e) = 0;
  frame_dialog_item_box();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_000035f8; source: ID04.c. Recovered name: map_view_user_item_proc [PROVEN] (iteration 200).
 * Decoded from ID04.bin bytes at file 0x35f8.
 * Pascal user-item procedure (DialogPtr at +0xa, item at +8; pops 6 bytes): calls draw_map_view_item(dialog, item). Reached through JT $b2 (CODE 0 entry -> ID04 0x35f8); installed for item 8 of DLOG 137 "Map" by run_map_dialog (0x39a8).
 * The following bytes 0x3614..0x3900 (not exported by Ghidra) are track_map_bearing_and_distance [STRONG INFERENCE name] [PROVEN, bytes]: C args +8 DialogPtr, +0xc EventRecord *. GetDItem(item 8), GlobalToLocal, PtInRect; while the button is down (StillDown $A974 / GetMouse $A972) and the mouse is inside the map: XOR-draws (PenMode 2, $A89C) a line from the map centre to the mouse, erasing the previous one; dx, dy from the centre; bearing via the function pointer A5-0x1056 (dx, -dy, dx*dx + dy*dy -> angle in 1/0x4000 turns) as 360 - angle * 360 / 0x4000, item 5 text = decimal + A5-0x2122 [STRONG INFERENCE: a degree sign]; distance = (A5-0x105a)(dx*dx + dy*dy) [STRONG INFERENCE: integer sqrt] * scale (settings +0x26) / (map width / 40), item 6 text = "<d / 10>" + A5-0x2120 [STRONG INFERENCE: a decimal point] + "<d % 10>" + STR# 129 slot 60 " mi."; on release the last line is erased. Caller: map_dialog_filter_proc (mouseDown).
 */
void map_view_user_item_proc /* Original: FUN_000035f8 */ (void)

{
  code *UNRECOVERED_JUMPTABLE;
  
  draw_map_view_item();
                    // WARNING: Could not recover jumptable at 0x00003612. Too many branches
                    // WARNING: Treating indirect jump as call
  (*UNRECOVERED_JUMPTABLE)();
  return;
}



/* Original: FUN_00003902; source: ID04.c. Recovered name: map_dialog_filter_proc [PROVEN] (iteration 200).
 * Decoded from ID04.bin bytes at file 0x3902.
 * Pascal ModalDialog filter (DialogPtr +0x10, EventRecord * +0xc, itemHit * +8; pops 0xc bytes, Boolean result). Switch on event->what through JT $2a (table at 0x3910: keyDown 3 -> 0x3920, updateEvt 6 -> 0x394e, mouseDown 1 -> 0x395a): keyDown Return / Enter -> *itemHit = default item A5-0x225e, true; updateEvt -> JT $492 (ID02 0x4d6a), false; mouseDown -> track_map_bearing_and_distance(dialog, event) (0x3614), false. Reached through JT $d2 (-> ID04 0x3902).
 * The following bytes 0x3976..0x3a54 (not exported by Ghidra) are run_map_dialog [STRONG INFERENCE name], JT $10a (-> ID04 0x3976) [PROVEN, bytes]: does nothing in mission 2 (Flight School, A5-0x12f8 == 2); GetNewDialog(0x89 = DLOG 137 "Map"); JT $472; item 8 user item JT $b2 (map view); 0x1b8(dialog, 2, 1) default ring; ShowWindow; loop ModalDialog(JT $d2): item 3 "Zoom In" -> settings +0x26 /= 2 while > 1, redraw the map; item 4 "Zoom Out" -> settings +0x26 *= 2 while < 256, redraw; until item 1 (OK); DisposDialog. DITL 137 legend: "+ - Hellcat, T - Primary Target, C - Friendly Carrier, B - Friendly Base, A - Airfield" - the characters drawn by plot_map_symbol_callback [PROVEN text].
 */
// WARNING: Control flow encountered bad instruction data

void map_dialog_filter_proc /* Original: FUN_00003902 */ (void)

{
  int unaff_A5;
  
  (**(code **)(unaff_A5 + 0x2a))();
  (**(code **)(unaff_A5 + 0x32))();
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00003a56; source: ID04.c. Recovered name: poll_click_or_key_event [PROVEN] (iteration 200).
 * Decoded from ID04.bin bytes at file 0x3a56.
 * SystemTask ($A9B4); GetNextEvent(everyEvent = -1, &event) ($A970); switch on event.what through JT $3a (table at 0x3a72: lo 1, hi 5, default -> 0x3a86): returns 1 for mouseDown (1), keyDown (3) and autoKey (5), 0 for mouseUp (2), keyUp (4) and any other event. The event is consumed either way.
 */
// WARNING: Control flow encountered bad instruction data

void poll_click_or_key_event /* Original: FUN_00003a56 */ (void)

{
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}



/* Original: FUN_00003a8c; source: ID04.c. Recovered name: show_about_dialog [STRONG INFERENCE] (iteration 200).
 * Decoded from ID04.bin bytes at file 0x3a8c.
 * GetNewDialog(0x8a = DLOG 138 "About Hellcats 1-Bit") when A5-0x137a == 1, else GetNewDialog(0x7f = DLOG 127 "About Hellcats"); returns at once when it fails. JT $472; ShowWindow; DrawDialog; SetPort; GetDItem(item 3), MoveTo its box, TextFont(1), TextSize(8); GetResource(vers, 1) ($A9A0) and builds the version text from its first word (major = high byte + 0x30 ...) - the rest (0x3b3c..0x3d3e) is not decoded yet. So A5-0x137a == 1 selects the 1-bit (black and white) variants, which matches draw_map_view_item (pattern fill instead of the blue sea) [STRONG INFERENCE]. Reached through JT $162 (-> ID04 0x3a8c).
 */
// WARNING: Control flow encountered bad instruction data

void show_about_dialog /* Original: FUN_00003a8c */ (void)

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


