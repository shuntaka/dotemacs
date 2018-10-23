;;##########################################################################
;; Index
;;##########################################################################
;; 1. debug
;; 2. Basic Settings
;; 3. Key Binding
;; 4. Manipulating Buffers and Files
;; 5. Moving Cursor
;; 6. Input Support
;; 7. Search and Replace
;; 8. Making Emacs Even More Convinient
;; 9. External Program
;; 11. View Mode
;; 13. For Programming
;; 14. Create Documents
;; 15. Helm & Anything
;; Color Theme and Font
;; Manipulating Frame and Window
;; For HTML and CSS
;; For SCSS
;; For JavaScript
;; For Perl
;; For Yaml
;; For SQLPlus
;; Miscellenious


;;===========================================================================
;; 1. debug
;;===========================================================================
;;----------------------------------------------
;; debug
;;http://stackoverflow.com/questions/5413959/wrong-type-argument-stringp-nil
;;----------------------------------------------
;; (setq debug-on-error t)


;;=================================================================
;; 2. Basic Settings
;;=================================================================
;;----------------------------------------------
;; append the  directory and its subdirectoreis to the load-path
;;----------------------------------------------
;; define add-to-load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; add directories under "elisp", "elpa", "conf", "public_repos"
;;(add-to-load-path "el-get" "auto-install" "elisp" "elpa" "conf" "public_repos")
(add-to-load-path "elpa" "public_repos")

;;----------------------------------------------
;; elpa
;;----------------------------------------------
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;;----------------------------------------------
;; color-theme(zenburn)
;;----------------------------------------------
;; set color-theme here before any style settings
;; since this would overwrite any style changes made before this
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;;----------------------------------------------
;;font
;; https://gist.github.com/mitukiii/4365568
;;----------------------------------------------
;; (add-to-list 'default-frame-alist
;; 	     '(font . "DejaVu Sans Mono-10"))
;; (set-face-attribute 'default nil
;;                     :family "Ricty Diminished Discord"
;; 		    :height 240)

;; Monaco 12pt をデフォルトにする
(set-face-attribute 'default nil
                    :family "Monaco"
                    :height 200)
;; 日本語をヒラギノ角ゴProNにする
(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Hiragino Maru Gothic ProN"))
;; 半角カナをヒラギノ角ゴProNにする
(set-fontset-font "fontset-default"
                  'katakana-jisx0201
                  '("Hiragino Maru Gothic ProN"))

;;----------------------------------------------
;; from Emacs Technique Bible Basic Setting
;;----------------------------------------------
;;; 履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ファイル内のカーソル位置を記憶する
(setq-default save-place t)
(require 'saveplace)

;;; 対応する括弧を光らせる
(show-paren-mode t)

;;; シェルに合わせるため、C-hは後退に割り当てる
;;; ヘルプは<f1>
(global-set-key (kbd "C-h") 'delete-backward-char)

;;; モードラインに時刻を表示する
(display-time)

;;; 行番号・桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)

;;; リージョンに色をつける
(transient-mark-mode 1)

;;; GCを減らして軽くする（デフォルトの10倍）
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;;; ログの記録行数を増やす
(setq message-log-max 10000)

;;; ミニバッファを再起的に呼び出す
(setq enable-recursive-minibuffers t)

;;; ダイアログボックスを使わないようにする
(setq use-dialog-box nil)
(defalias 'message-box 'message)

;;; 履歴をたくさん保存する
(setq history-length 1000)

;;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)

;;; 大きいファイルを開くときに警告を表示する 10MBから25MBへ
(setq large-file-warning-threshold (* 25 1024 1024))

;;; ミニバッファで入力を取り消しても履歴に残す
;;; 誤って取り消して入力が失われるのを防ぐため
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;;; yesをyで応答するように
(defalias 'yes-or-no-p 'y-or-n-p)

;;; goto-line ショートカット
(global-set-key "\M-g" 'goto-line)

;;----------------------
;; Hilight the current line
;;----------------------
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;;----------------------------------------------
;; make highlight the current line light
;; http://rubikitch.com/2015/05/14/global-hl-line-mode-timer/
;;----------------------------------------------
(defun global-hl-line-timer-function ()
  (global-hl-line-unhighlight-all)
  (let ((global-hl-line-mode t))
    (global-hl-line-highlight)))
(setq global-hl-line-timer
      (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
;; (cancel-timer global-hl-line-timer)


;;----------------------------------------------
;; highlight between two parens
;; http://syohex.hatenablog.com/entry/20110331/1301584188
;;----------------------------------------------
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#ffff00" :weight 'extra-bold)

;;----------------------------------------------
;; ターミナル以外はツーバーとスクロールバーを消す
;;----------------------------------------------
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))
(when (eq system-type 'darwin)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;;----------------------
;; show the file path for the currently opned file
;;----------------------
(setq frame-title-format "%f")

(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#ffff00" :weight 'extra-bold)


(setq redisplay-dont-pause nil)

;;=============================================
;; 3. Key Binding
;;=============================================

;;----------------------
;; use command key as meta key
;;----------------------
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;;----------------------
;; map C-h to backspace
;;----------------------
(keyboard-translate ?\C-h ?\C-?)

;;----------------------
;; use C-c l for toggle-truncate-lines
;;----------------------
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;;----------------------
;; use C-t for toggling the windows
;;----------------------
(define-key global-map (kbd "C-t") 'other-window)


;;----------------------
;;sequential.command.el
;;----------------------
;; (require 'sequential-command-config)
;; (sequential-command-setup-keys)

;;----------------------------------------------
;; 3.6 define-key
;;----------------------------------------------
(defun line-to-top-of-window () (interactive) (recenter 0))
(global-set-key (kbd "C-z") 'line-to-top-of-window)


;;=============================================
;; 5. Moving Cursor
;;=============================================
;;----------------------------------------------
;; point-undo
;;----------------------------------------------
(require 'point-undo)
(define-key global-map (kbd "M-p") 'point-undo)
(define-key global-map (kbd "M-n") 'point-redo)


;;----------------------------------------------
;; goto-chg.el
;;----------------------------------------------
(require 'goto-chg)
(global-set-key (kbd "M-i") 'goto-last-change)
(global-set-key (kbd "M-j") 'goto-last-change-reverse)

;;----------------------------------------------
;; Vim H, M, L
;;----------------------------------------------

(global-set-key (kbd "C-M-h") (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))
(global-set-key (kbd "C-M-l") (lambda () (interactive) (move-to-window-line -1)))

;;----------------------------------------------
;; ace-jump-mode
;;http://rubikitch.com/2014/10/09/ace-jump-mode/
;;----------------------------------------------
;; ヒント文字に使う文字を指定する
(require 'ace-jump-mode)
(setq ace-jump-mode-move-keys
      (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil))
;; ace-jump-word-modeのとき文字を尋ねないようにする
(setq ace-jump-word-mode-use-query-char nil)
(global-set-key (kbd "C-o") 'ace-jump-char-mode)
;; (global-set-key (kbd "C-;") 'ace-jump-word-mode)
(global-set-key (kbd "C-M-;") 'ace-jump-line-mode)


;; ;;----------------------------------------------
;; ;; ace-pinyin
;; ;; http://emacs.rubikitch.com/ace-pinyin/#comment-12207
;; ;;----------------------------------------------
;; (require 'ace-pinyin)
;; ;;; echo a | cmigemo -q --emacs -d /usr/share/cmigemo/utf-8/migemo-dict
;; ;;; をa〜zで繰り返し、最初の[]の文字を取得することで生成
;; (setq ace-pinyin--char-table
;;   '(
;;     "[母餅渉恤閔憐遽慌鰒蚫鮑袷淡∃主袵衽歩垤蟻麁凡蘭塔露著表霰非諍抗検更革改現爭競争洗殿鉱予豫粗嵐恠彪妖殺禮絢怪綺彩肖漢過謝謬誤礼操綾飴黯菴罨鱇鮟餡闇行按諳晏鞍暗鶩鬚鰓顎喘発肋豈嫂兄騰崇県購贖网罔咫與中鼎新邉邊辺恰頭價価値游遊畔畦堋杏梓与衵袙憬坑孔案侮窖強貴讎讐徒仇痣黶欺鮮字糾嘲薊姐姉曙炮焙炙蜚薹膏脂油危鐙虻泡踪蹟能痕跡東預纂蒐乢輯聚遏軋誂羹壓惇集陸敦暑淳篤熱扱暖温遖斡私圧焦汗桜奥央櫻媼奧塰蜑餘遍周普剰蔗余尼雨甘天押凹樗楝溢艶庵鰺網戯簣鯵味渥軛堊圷憧欠踵幄握芥齷厚漁鯏蜊蕣淺麻浅龝煥晢晰呆朖光啓旭滉昜晄輝亮顯陽璋鑑亨聡洸曠昿諦朗哲顕彬晶賈章商穐彰晃昭晧秋瞹欸阨穢埃噫姶文隘粟曖鮎藹饗靉挨間相哀葭趾朝晨愛蹇跛跫脚蘆葦芦桎鐐足赫淦燈赧紅旃朱茜藜銅赭曉閼暁垢皸皹證灯絳暴証赤扇呷黝榮碧葵蒼煽仰青穴倦厭遭当悪椏敢襾或彼宛安該褪揚娃飽會荒飫浴上嗚韲哇和痾亞開阿併唖吾在當婀惡明合逢擧挙充編遇有あａ藍金＠∧＆&論∩∠銀会∀域空↓↑⇔⇒←→⌒後Ц亜米¨´｀＾’≒〜ÅАαаアΑa]"
;;     "[鯔鰡堀本凡盆煩梵骨凹歿鈕釦沒渤没樸穆睦濮目攵攴朴木僕墨卜牧星懋蠎黽网旁罔謗儚鉾甍袤胞貌牟瑁卯髦虻眸鋩榜抱茆蒡肪鵬旄氓蟒冐乏惘妨帽昴忙剖冒忘茅膀妄尨厖膨貿防紡滂茫望亡傍謀某拇謨坊姥牡菩簿慕褒掘母誉模乾募暮呆暈干姆彫保戊惚墓ぼ幎覓汨冖巾羃冪紅瞥韈鼈蔑塀汳遍抃瓣辯卞辧辨宀采湎辮眄冕勉娩弁可邉邊辺べ船房笛斑渕縁鞭淵渊椈樗太袋深葢盖蓋豚節勿佛物震勃蚋風鰤馼蚊聞文嘸武不歩舞撫伏廡蕪撃奉侮誣葡錻無分憮拭撲蒲吹打部葺振悔毋ぶ米謐人匹浸額鐚跛！広開繆別謬泯旻岷梹緡罎紊檳頻壜愍瓶鬢閔憫敏貧便帛闢辟百白票杪緲″猫憑鋲屏渺眇平錨苗秒描廟病嵋寐尾濔眉弭備火比枇美日琵毘未贔瀰引麋糜弾靡微糒媚縻び速早林針尿拂腹散払祓原旛鷭蠻幡塙旙鑁悗挽判棒絆版輓蕃板播礬阪坂磐番盤晩萬蛮万箱蠅芒挟伴蜂桴枹鉢撥働畑畠屎糞鼻花端離話V魅秤許拔魃罸筏閥橋箸走柱藐獏貘寞暴漠瀑麥縛博駁莫驀爆霾狽吠憊賣唄楳杯苺培煤黴貝焙賠買陪売倍梅媒跋伐末幕曝抜罰歯塲刄晴羽刃芭婆庭貼罵化張這馬場馳葉ばｂ“仏■□⊥下底×｜−‖＼∵麦ボバ］［｛｝ブБΒベβбビb]"
;;     "[恐怖惟怺※米暦轉頃鯤坤鶤艮袞琿悃壼獻很狠建棍魂蒟菎滾梱溷献痕渾墾恨懇根杪王挙泥裔樸鞐熟枹醴蛩徑蹊径溢毀零錯苔拒亊箏判斷諺理断盡尽辞琴言異事今壽寿鯒冀希礫鯉拱齣狛細腓昆拳瘤鮗兄近谺応應答是爰凩惚兀榾忽輿甑腰拵拗鏝鐺浤惶伉犒哮鮫湟蛤狎慌槹礦扛扣搆椌閧絖哽淆闔閤鴿鏗肴仰匣覯餃杲遘呷窖肓湊藁敲幌桁皐倥猴紘訌缸昊詬凰靠遑頁袷羔洸徨岡峺寇冓困棡亙鵁壙鍠鱇晄誥洽啌效耗吭峇釦傚昿稾肱隍頏磽昴絋逅冦砿鬨糠矼黌爻塙烋盍崗汞胱恆畊蚣熕嫦皋紺鈩絳閘蒙氷冰郡蛟槁候楮媾溘后蝗酵嚆犢稿亢哄睾梗慷笄郊効岬肛項巷鑛洪佼狡叩昂勾喉晃滉剛糀晧曠宏控恍侯耿煌膏坑港皓皎向江膠虹巧鴻鉱興衡浩厚耕弘綱抗購講恒薨溝鋼更航孝校行肯荒皇光高好詰谷棘轂哭釛斛梏尅槲告刻酷穀呱痩壷拠去懲鴣詁⌒沽混觚箍兒餬虚雇錮漉蠱児蝴葫壺跨捏己滸皷黄女杞超瑚漕怙倒罟糊濾粉辜菰股琥乕瞽鈷濃越扈瓠胯誇估凅肥孤弧夸蛄踰転湖故込木恋古虍娘戸粐袴楜冴媚冱鼓放乎滬戀虎こ芹鬩鐫揃喘燹韆綫栫痊槫涎吮僣筌纖舛專簽刋倩舩旃槧苫亘沾饌湶濳仟阡斬箭薦茜荐筅錢擶纎磚孱翦濺甎僊癬蟾銛孅牋羶箋贍殲殱闡賎餞羨顫甅竰糎陝銓踐閃∨潺遷銑栴剪煽譫僉瞻践栓跣疝詮銭穿戰尠繊僭腺泉仙嬋淺擅鮮専扇浅船蘚線撰宣洗選煎戦尖先忙倅伜逼狹狭蝉旋緤啜§泄絏渫椄卩洩紲薛攝鱈刹褻浙竊窃截殺説拙摂節切籍瘠迹蹐蹠威螫績裼蓆跖晢勣晰跡夕鶺雪寂∬∫碩惜析隻席萋菁躋嘶撕犀擠婿睛韲牲甥貰齊晟情穽醒筬齏瀞淒歳栖棲掣腥逝斉惺臍旌悽整凄靖製晴畝迫攻勢丗塞畆急世脊堰糶瀬せ配栩椡櫪椪檪椚箜櫟含纐婚糞癖潛潜鵠凹窪縊跟頚軛珞頸諄鞋窟履狐轡覆沓碎砕条降件頽崩屑釘莖茎陸杙杭掘崛倔鶏鐃藥擽薬楠誓梳串釧與与挫籖鯀鯨鬮籤隈熊艸嚔藾叢鏈腐鎖ξΞ茸菌楔草圀國邦国嗽漱吻劫腔φ刧粂熏皸醺桾皹勳裙崑燻訓勲葷君委钁企咥銜桑某冥眛峅昏暝鮓比闇位鞍藏暗倉廚厨涅〃ゝヾゞ々仝ヽ公曇雲蜘佝栗狂包胡俥梍枢畔鐵★玄黒来吼桍苦徠區吁暮久怐紅眩孔駒宮組呉瞿奇供区來鳩惧口工垢衢朽繰九玖汲絎劬枸窶煦懼句貢狗９庫嶇く埀謐Σσ蘂蕋蕊痺茵褥鵐蔀鷸鴫入責霑蔵嶌了縞嶋島凋搾澀澁渋縛暫屡柴荵凌鎬忍簧舖慕↓襪認从從．舌扱罔Θθ虐粃秕椎椣貎尿臠肉猪衣榻黙蜆恵楙誠茂成繁惻鋪陣頻閾櫁樒鹽汐潮隰瑟蟋櫛嫉隲疾蛭悉漆躾膝失室沒鎭沈滴雫賤鎮靜静顰尓爾聢乍然併□■◆◇倖幸貭叱征質柵卯滋撓品鬼鍜錏錣凝痼而拉設垂萎栞襞吝咳什導汁験徴著記印☆〇銀城報調蝨虱白濕湿七標僕笞楚霜臀退斥後尻寫柘卸砂冩者舍炙♯＃暹諜喋煮這西娑沙謝紗鯱奢赦洒捨鮭瀉釋蜥決炸蹟刳鑠妁斫勺抉爍皙昔芍酌爵折癪笏赤綽灼杓石尺赭写鷓積遮舎車射斜釈社娵麈娶蛛諏洙殳鬚侏繻銖戚倏肅菽蓿蹙叔俶淑夙粛宿縮殊珠趣卆恤蟀出繍溲遒讐洲綉駲讎楢逎酬楸穐鷲緝蹤岫萩甃泅螽葺售收驟舅囚姑蓚皺鞦銹脩輯醜習羞酋聚舟秀祝袖拾啾蒐収執衆愁就臭蹴週終褶州宗集秋椶棕朱撞種修周手酒首須雋濬皴蕣悛儁惷墫順蠢舜旬浚竣峻駿逡筍瞬俊岑臻寢槙脣娠譖鷆晉忱齔嗔袗怎蔘哂蓁矧譛鷏疹畛甄縉瀋箴軫榛秦襯診鉐津駸讖紳斟針唇呻蜃賑芯瞋振殿侵晨薪辰震宸森眞愼伸慎寝晋進審深親臣鍼申心宍信真新薯嶼杵苴處苜墅砠藷狙胥岨黍蜍渚曙背緒雎蔗庶処署所暑聲稍艢鷦橸劭厰舂將腫政嶂蛸錆枩廂懾韶峭邵奬炒慯筱摺鬆顳樅星鯖樵訟梢敞橡霎廠秤篠咲燮愴愀甞湫獎井囁觴鍬剿妝庠浹簫陞殤淞誚升璋醤青慫従逍倡竦爿薔笙樟装肖菖＜≦湘誦聳檣稱声裳蒋蕉嘯慴盛精清霄鈔粧鏘悚悄蕭彰哨瀟焦憔匠鍾償鞘瘴漿頌詔妾沼請唱薑庄渉障奨床牀娼椒宵聖抄荘傷性相生召銷賞猩症昭燒猖尚昌少憧晶祥紹承證笑焼将照招詳章消硝証掌商昇小屬謖寔觸稙軾昃矚稷拭嗇穡禝属燭贖囑嘱織蝕式喰蜀殖諸初触埴植食職賜閇阯仕咫仔駟伺摯之鷙染肆凍至嗤翅衰錙祉釶巳笶浸肢脂貲尸篩諡司四士蚩緊祗姉糸粢氏侈厶厮思贄嗜嘴弑熾〆滲若髭敷啻此師梔耆絲痣次誌刺知歯恃茨及舐沁緇諮獅駛試俟嗣趾志示止如咨砥識笥幟岐揣呰詞自弛漬梓指始矢卮姿紫匙芝詩史瓷廝輜使絞齎偲施時締旨屎巵資孜址只覗齒恣徙誣豕泗耜死觜妛茲祠枝占竢視市痴領祀雌強私沚謚し癢糜粥痒麹輕骨業軽鰈鰔餉通瓶龜甕亀鴈獵鳫殯K猟雁鳧鳬釀髢氈鴨側巛躱厠廁磧瓦獺翡為裘皮→紮〜搦苧碓柄軆體躰躯身体鴉犂烏絡空唐榧茅揀鐶寰稈丱厂鑵歡坎篏捍卷扞撼豢皖淦歛戡驩瞰盥杆勸讙羹蒄陷瀚啣繝拑嫻罕奐羮憾骭澗潤鸛澣康樌懽嫺莟酣觀橄涵渙堪覡巫鉋随萱簪舘艱咸翰柬駻悍燗槓浣邯稽攷宦考棺潅閂煥鉗疳癇凾函鹹桓款緘箝諫諌轗旱坩侃鰥　館莞橇韓患灌勧菅奸刊柑肝桿看緩寒干嵌廣広竿貫巻敢漢環間歓閑喊陥喚甘監寛管慣完汗乾艦幹官観壁椛屍姓庇鞄芳蔓千鯑一勘蜻⊃影蔭陰景＊梯棧筧庚辛柧門廉乞癩κ川Κ合《｝‘”〈’）“｛》〉囓柁悴鮖舵鰍梶錺餝飾篭籠孵卻歸皈還省顧楓槭却帰反返守督髮帋祇韮主裃雷髪紙鉦矩曲予鐘樺沫偏騙語潟刀象模仇固硬傍難容忝辱頑形方旁型肩風滓微翳幽掠綛纃絣緕擦糟鎹粕春蠍猾瞎戞轄剋蝎喝擔劼∧黠濶恰聒蛞餓鞨羯筈曷刮鬘蘰桂闊括嘗捷豁渇担滑松堅鰹功割戛活疽暈鵲瘡傘嵩重襲葛笠堵硴牆墻蠣蛎柿掲罹關抱踵嬶嚊拘関係貌顏郁薫顔母感窰釡罐鴎框叺喧竃竈窯缶釜蒲鎌數数槝栢膳傅畏賢橿姦樫炊爨喞圍託囲鈎『鉤「』」限鍵（傾禿蕪鏑頭齧被兜敵適哉必要称鼎彜彝鬲叶片哀愛悲鋺蛇鉄蜩神奏金楫裹磆餅徒褐糧粮幗槨壑∠膕寉狢咯覈膈貉茖擴蠖覺掴愨椁骼癨埆穫嚇隱殼霍礁恪擱匿撹攪喀廓較郭〕［【〔】］殻挌劃閣格隠覚矍革核鶴馘攫獲拡客隔角確枴醢喙价懈褂揩峡獪觧椢茴丐誨櫂誡畍匯夬廨械徊蠏隗迴恠囘嵬壞榿蛙瑰乖浬鰄傀糴柏街鳰懷蛔蠶蚕邂蟹潰壊恢腕芥垣楷會拐悔詼諧皆疥界魁偕改繪貝胛絵甲快灰槐晦懐介解回廻階塊戒開会怪海縢篝炬赫耀輝冠鑒鑑各屈鏡痂買墟淅刈蝌茄珂稼譁彼崋駈個狩懸咬價哥醸畫下支代描翔迦糅禾藉科勝訛課換涸譌闕賀苟萪花上掛蝦个軻踝馨貨枷箇呵家画霞伽訶缺罅書何佳価柯賈戈噛借禍菓香駆袈枯繋ヶ跏貸顆耶河嫁替遐夏架日嗅舁葭華蚊斯火易變苅渦謌夥驅和過飼歌鹿暇黴笳嚼假窩咼搗兼寡苛渮果嘉卦厦廈靴嘩賭掻且仮啝克嗄欠蝸化舸ヵ荷可堝かｃ・…塩閉倶錫呼∩取籐加交цЮФЩЪАмСнПЫЛИЗеохсДвщрМЯфжйКЭбШуХиаёЬЖэТРВшдГЙлъУпОьгкБзтюНЕыяЁ♪╂┼┿╋×●◎○銅∪χΧ子Чч株Ц珈，、色ク競衝構簡制≡変接カ└┓┗┐┏┛┘┌正コ℃¢セシc]"
;;     "[共吃巴鑼錚鳥鶏響嫩緞丼呑曇貪鈍肭遠蚌溝隣鄰塢床処所年時鰌鯲鰍得徳讀獨髑毒読陶耨嫐橈藤桐働鐃通僮閙儂ゞ萄撓々恫瞳憧鬧≡⇔撞慟導〃仝洞堂瞠艟獰胴銅童動同道堵何融退戸度駑取奴呶弩努録怒孥留土止解ど瓰竕凸竍籵瓧禰泥捏溺寺棯沺鈿佃甸淀畋黏澱臀傳殿電照でヅ鶴辛強妻綱勤伝筒包做造作尽机月冢塚遣疲使釣連付積漬突図詰津吊づヂ中近力地痔持ぢ種棚倒彩濃逹畳諾濁゛玉默球魂騙谷点館舘嶽竹岳高蛸凧怛妲獺奪脱臺梯餒岱戴廼迺弟平内醍橙］［題＞≧第台代大鱈頼便誰樽懶怠椴灘斷黙旦煖彈暖談段断檀団團壇弾男唾騨澑垂懦儺駄拿出抱墮駝荼兌立雫堕橢惰田鴕妥柁朶舵陏炊蛇娜沱拏建溜打佗陀楕だｄ直◎．、，丶\.・‥…＄“”↓‡†—┤達°℃独ド÷◆◇ダジдΔデδ∂Дd]"
;;     "[瘧腮偉鰓衿撰襟鹽掾覃薗渕湲爰黶圜捐悁¥櫞蜒篶艷讌魘渊轅檐媛垣閼簷鳶鴛焉嫣宛閻衍臙閹槐⌒援筵淹厭寃淵掩烟嚥圓沿宴奄蜿煙袁艶焔炎怨鉛園苑偃冤延婉遠堰燕演塩円縁刔刳抉猿狗描択鰕箙蛯蝦貊狄胡戎夷乢靨咽噎粤鉞戉桟悦閲謁掖伯亦蜴懌繹奕越役驛疫易益腋駅液衡潁咏翳塋娃瑩殪瓔贏曵纓頴珱裔蠑營洩楹瀛睿泳縊榮暎瑛曳盈郢影詠穎嬰鋭叡映営栄永画會惠繪猥杖畫榎絵回衞選柄獲衣得荏懷慧恵枝餌会重囘衛笑依江え─━┯┬┳┰┸┴┻┷фФ＝≡⇔∈∋рРмМｅН→英∃式！ΗηСсЛлэЭエΕεe]"
;;     "[麓梺冬賁枌汾′濆吩刎氛雰糞褌忿墳吻紛焚扮分粉顫舊揮旧故震篩奮隹古衾襖贅燻筆鰒総總惣絃房閼鬱塞鞴章郁史艦簡札耽吭鰾笛文罧節苳蕗淦舩艙舷舟船肥太懷懐≦≠≧＞＜≪≫渊淵渕縁盖葢再弍蓋双藤鯊蒸潭鱶殕楓瘋封諷怫黻拂髴彿祓憤恚慍二払沸拒防愎蝠箙茯輹蔔腓⊇⊃脹膨嚢梟袋含⊆⊂袱覆輻腹幅復馥服副複福深觝觸怖触冨仆膚狂麸附生蹈腐普婦伏噴付老傅歩柎罘孵賻桴匐踏郛敷巫不負鯆風夫坿殖吹鮒榑經俛府臥咐経葺阜振孚父践俯拊腑賦蜉斑埠芙赴拭履溥麩符布俘畉趺舗降誣譜増鋪苻訃扶斧更芬呎飜翻ふｆ鉄♀∀¶富⌒金佛仏偽誤♭弗浮フΦFФфφf]"
;;     "[頃殺米魂權諢艮勤権鮴好蓙応駒事若琴亊毎如鏝込埖塵氷声肥聲腰拵心戀恋国石獄敖濠嗷熬壕軣刧噛哈盒遨拷囂轟毫傲鼇郷劫≡号豪剛互蜈子牾呉茣後兒唔午后5児吾瑚極５超護伍宕齬娯忤晤珸期庫寤梧五越悟檎炬誤碁沍醐篌冴ご〓鬩屐隙郤戟檄闃鷁撃激劇貎霓麑倪皃黥囈猊迎鯨芸藝蘖囓齧監痃广芫彦呟愿軒舷眩源儼衒弦絃験諺言現限幻玄減原毛実拐夏解蹴偈觧睨下げ靴腐草種口薬糞癖胡萸茱串遇藕嵎宮寓隅偶黒栗蔵倉鞍位昏羣麕郡群軍苦周包車狂愚狗食禺惧具麌暮壷組倶虞颶壺弘ぐ衣君嫌裂際牛憖岑垠斤崟吟銀禦圄圉馭閠嶷魚玉漁翹嶢繞堯尭澆御痙曉蟯驍僥仰業暁凝行瘧謔虐逆議祇義擬宜木城着伎誼萓魏嶬僞技犠気艤切犧礒巍欺決祁戯妓斬蟻沂儀戲偽疑羲曦ぎ巛皮川革乾側通絡殻辛柄烏鴉嚴阮鳫巖貫厳偐頷嵒岸厂⊃贋龕強岩翫鴈丸雁玩癌元願眼巌含頑神紙髮髪上鐘金係皈歸肯帰返固方潟語刀難型形鰹歹垳顏顔釜蟇窯鎌蒲蟹傘重笠號垣樫頭月合齶諤鄂學斈樂壑鍔萼愕嶽咢鰐額岳顎楽学劾既愾礙磑崖乂葢剴漑涯盖垓睚崕亥啀艾駭皚該咳階孩碍芥害鎧街凱慨概蓋骸外画伽峨駕ケ変書換餓牙勝訛掛賀雅鵞呀狩蛾代畫刈買衙娥ヵ鵝訝峩俄芽哦果我莪駆貸ヶ借替臥河が≫＞ｇ瓦≧ガゴηΝΗΠδπΞχΑλΔσζτοφΤΣξΒψΡΩβΖΟυΥιαΘθεΨκΙΦμΧωΛΕΜρΚνギグГгΓゲγg]"
;;     "[洞袰亡滅幌濠壕畚笨略艢檣焔炎仄朖朗塊程施滸幾殆缶熱解屠榾螢蛍骨細本＊※糒擅恣縦星桙戟戈綻祠誇埃矛鉾堀頬棒豐抔蔀泙弸棚朴皰舫堋膀勹枋峰峯袍鞄磅垉鴇褓篷呆怦麭苞葬琺寳炮鵬寶繃魴鋒髣逢朋烹鳳彗箒俸焙蓬烽幇抱崩訪泡澎彷縫捧萠萌彭包胞邦倣飽庖疱奉豊砲硼報宝攴攵蹼瀑樮北賞抛穗脯舖穂畝捕恍餔襃褒哺埔逋欲掘輔堡誉耄黼葡哮彫吼咆葆保浦譽惚ほ謙遜篦廰廳篇駢褊貶諞胼蝙翩變∂遍返騙編扁変暼丿諛諂隔凹臍巳蛇蔕蒂瓸竡粨闢甓癖躄璧劈碧壁餅坪竝幤嬖閇聘娉箆蔽塀病并陛屏炳瓶斃幣弊敝併閉並戸邊歴辺圧折舳減屁邉へ麓梺冬♭賁枌汾′濆吩氛雰糞褌忿墳吻紛焚扮分粉顫舊揮旧故震篩奮隹古衾襖贅燻鰒陰総總惣絃房閼鬱塞章郁艦簡補札耽吭鰾笛芬呎文罧節苳蕗淦舩艙舷舟船蒲懷懐≦≧＞≪≫渊淵渕縁盖葢弍蓋双B藤蒸潭鱶殕楓瘋封諷佛怫黻髴彿憤恚慍仏F弗沸φΦ拒防愎蝠箙茯輹蔔⊇⊃嚢梟袋含⊆⊂袱覆輻復馥副複福深觝觸怖触冨仆狂麸附富蹈腐普婦伏噴付傅歩柎罘孵賻桴匐踏郛敷巫不負鯆風夫坿殖吹鮒榑經俛府臥咐経葺阜振孚父践俯拊賦蜉埠芙赴拭溥麩符俘畉趺舗降誣譜増鋪苻訃扶斧更ふ鶸禀蘋彬嬪斌繽殯賓擯牝貧頻瀕稟品葫怯晝飜蒜蛭昼綬胙紐鰭∝片衡鮃閃鵯辟百媛姫仭尋太宥絋擴展仞拡拓拾祐恕紘泰煕熙裕啓洋寛弘宏浩廣広驫彪冰凭雹飃馮殍飆俵髟冫飄豹漂驃剽慓嫖兵憑票評標平表燧老捫拈撚捻歪籖籤柊魃旱秀跪膝蜩羆佗攣−低隙閑暇雛髯鬚髭¬蹄濳潛潜顰密窃鬻提匏瓢蠡瓠壽恒央廂尚寿久率蟆痙蟇丙丁女史孤獨独稘斉斎準均倫等≠單偏単他仁瞳人1１柆蔆拉柄杓犇◆◇菱醢醤曾蘖彦酷漬浸鶲額聖肱肘熈芒光膕控皹皸響罅僻鰉逼疋篳匹畢蹕柩棺弼櫃謐坤未羊筆必襞養饑＜（「【←『左灯鄙臂庇朏退彼卑皮疲秕裨梭斐魅妃砒丕陳轢髀暃否樋霏惹匪俾祕痞費氷肥飛檜碑悲毘蓖泌秘鞴挽桧贔避痺引蜚火妣比鞁日貔乾牽扉匕碾杼脾菲罷冷紕曳昜譬批披緋干轡豼狒索被ひ布鱧釖鉤蝟梁鍼磔針禳肚腑腸孕原拂祓払玄遼温請腹陽遙悠東遥治春頓捷鮠鶻駿疾囃林隼胖潘釆絆泛鈑蟠磐樊笵畔膰拌氾坂范凡燔楾洪瘢翻板攀゜大伴煩槃袢斑判範藩繙蕃版搬叛班阪般販犯汎帆頒反侍鯊櫨祝？硲間劇勵激烈励速蝿蠅飯省勢彈外筈弭辱逸毓育齦浮阻難掵憚幅巾柞母翅旌幟側旛圃将旙傍働鰰機叩疥畠籏幡畑旗斜鴿再鳩開秦跣膚肌裸弾薑椒壱哉一甫創弌馨壹元始鋼芳夾剪鋏螯挾挟脛萩餞贐離塙萼英蕚衄衂縹譚咄放噺話洟甚鼻華花觜迸枦赱奔艀婢梯燥箸柱走橋□筐箪匣凾繁方運匚筥箱函亳蘗魄佰狛珀膊愽璞柏栢粕陌岶擘箔舶泊搏迫帛拍圖諮企測秤謀量計図儚捗袴伯博墓癶釟髮秡溌肇廿二初椀蓮８♪鉢蜂發髪服半法白醗薄八発琲孛埴拜睥吠旆湃牌擺裴坏盃霈珮碚入沛榛杯悖—廢腓誹徘稗癈肺俳憊輩背鷂胚廃排拝敗灰配蛤濱浜刃刷派爆脹恥生佩破榮坡穿着禿羽耻碆簸慙跳刄菷爬食矧陂腫晴菠端栄杷琶跛歯垪捌頗馳嵌葉愧剥刎叭羞巴匍帚怕笆把映播覇霽吐霸帶貼這張齒撥葩果填芭掃暎膨玻履早はｈ─━┘┛┻┷┴┸┐┓┬┯┰┳┨┥┤┫┿┼╂╋波‐フ★☆非ヒホヘハh]"
;;     "[Ηη賤卑鄙苟嫌弥薯妹芋藷夢艷鑪鈩彩鱗色鯆忽綺貸甍応答愈圦杁蚓茵霪婬飮蔭贇酳韵寅尹胤隱氤湮堙廴音飲慇韻咽淫殞姻隕院允殷隠陰窟巌巖頌祝鰛鰮鰯岩磐¥円鼾歪弋弑抱懐贅肬疣狗戌乾犬諱坐在未汝誡警戒縛今Εε曰禾稻員因蝗嘶鰍電引躄誘動忿≦鵤錨碇怒雷霹霆凧桴筏魚S菴庵彌雖家尿荊棘茨祈祷命猯豕古聿鎰乙鴪伍軼樹慈悼慯愴労格到至傷鼬頂戴病徒致鈑痛板柞砂沙些聊潔諍烈功諫勳勇勲漁諌憇＝憩粹熱粋憤域閾勢勤忙急磯孰焉湶泉厳何弄苛≧范鎔啀毬訝燻息挑絲縷厭營営愛稚幼緒遑暇糸弌壹肆莓苺櫟著市碑鐓礎甃臀弩石犧犠牲池溢Y佚壱1１粥毓鬻燠礇的戦戰軍郁幾育一稲否飯揖詑居維将洟挿容良行緯活矮渭慰逸往爲唯斐饐炒生凍頤出威胃矣姨要肄謂僞委云為五萎煎蔚鑄井恚位懿醫貽好以ゐ噫怡依畏違易熬莞斎鋳如夷移亥帷胆圍彝已彜淹痍猗尉椅逝鰄異熨囗善去忌倚惟癒偉堰遺偽医射幃鮪率可韋意痿猪衣逶囲李言詒彙苡い氷йЙ→⇒⊂⊃▼▽伊ｉ印入∞吋∈∋∬∫∩ＩイиИ私ιΙi]"
;;     "[塩縞嶋嶌島橲衄竺宍衂舳忸軸舌喰食直凝實昵実印尻贐潯糂盡仭進稔刄臣恁仞儘侭訊俥蕁迅刃靱荏甚靭燼櫁樒塵尽尋陣腎壬人洳杼莇蜍敍汝恕茹耡敘舒縟辱褥蓐溽所抒鋤徐絮叙序助嬲聶星絛茸孃瀞仍乘躡拯讓仗疉滌帖繩遶諚疊塲靜淨繞疂蕘壌釀驤穰禳襄壤生蟐如剩娘嬢錠静醸縄女尉饒丈成烝嫋穣擾丞盛杖場條条蒸貞状攘剰畳冗定浄乗情城上常譲愀鷲嬬得戍竪咒就讐懦讎濡聚詢凖隼盾筍徇笋楯篤蓴惇淳洵閏恂諄馴旬荀潤醇巡循遵順准殉純準襦誦需戌朮孰宿塾珠熟恤術述呪孺豎儒綬樹受授壽澁廿糅縱澀从鞣從狃揉戎拾中蹂神汁獸絨縦渋柔什充十従獣住銃重膩時侍孳兒二珥只冶餌邇茲怩死持子祀蒔嗣痔辞辭畤轜寺示亊弍自瓷史岻児以焦塒峙事敷路爾次慈寿滋粫耳知恃仕似至尓爺染字地磁除而柱仁士司璽迩醤鮭着鉐尺惹搦雀寂若弱麝闍蛇邪戯者じｊ┃│┝├┣┠┌┏．еЕ治яЯ日ЮюёЁЙйジj]"
;;     "[怖旃之惟怺薦米暦轉殺鯤坤鶤艮袞琿悃壼很狠漿棍魂菎滾梱溷痕渾墾恨懇根梢杪王泥裔樸鞐熟枹醴聲声蛩凍溢零錯苔亊箏判斷諺理断盡尽悉辞詞殊事壽寿鯒礫鯉齣狛腓昆瘤鮗谺応應答茲是爰試志心凩笏惚兀榾輿甑腰拵拗鏝鐺浤惶伉犒哮鮫湟鎬蛤狎慌槹礦扛扣搆椌閧絖哽淆闔閤鴿鏗肴仰匣覯餃杲遘呷窖肓湊藁敲幌皐倥猴紘衝訌缸昊縞詬凰靠遑簧袷羔洸徨岡峺寇冓困亘棡亙鵁壙鍠鱇晄誥洽啌耗吭峇釦傚昿稾肱隍頏磽昴絋倖逅冦砿鬨糠矼黌爻塙盍崗汞胱恆畊蚣熕嫦皋紺鈩絳閘蒙氷冰郡蛟槁候楮媾溘蝗酵嚆犢稿亢哄睾慷郊岬肛項巷鑛洪佼狡叩昂勾喉晃滉剛糀晧曠宏控恍侯耿膏坑港皓皎江絞膠虹巧鴻鉱衡浩厚耕幸弘綱抗購攻講恒薨溝鋼航行肯荒皇光高好谷轂哭釛斛梏尅槲石告酷穀呱痩壷子懲鴣詁凝沽混觚箍兒餬雇錮漉蠱児蝴葫壺跨捏滸皷女超請瑚漕怙倒罟小糊濾粉辜菰股琥乕痼瞽鈷濃此越扈瓠胯誇估凅呼肥焦孤弧夸蛄踰転湖故込恋古虍娘戸粐袴楜冴媚冱仔鼓放乎滬戀虎こ峻欅獸娟愆瞼搴騫愃惓涓權俔蜷鵑黔甄椦縣儉檢妍綣圈獻幵劔險謇劒顯虔暄劵臉鉉諠剱慊釼歉験慳捲倦遣羂嶮蹇鹸狷譴腱軒驗憲繭謙圏険硯倹献犬絢顕券劍剣見権研眷拳牽県建烟鑷言獣蓋涜吝削畩閲検貶健桁嗾抉歇獗尻厥碣偈蕨杰頡刔訐譎竭亅襭訣孑頁纈蹶桀穴傑結血挈挂夐醯匸盻煢瓊詣鮭冂絅憬綮畦冏剄檠勍奚迥枅笄蹊徑憇兮攜黥彑逕繼惠慧謦鷄系┥┳┯┤┣┨┓┿─┸┫╋├┼┷━│┏┰┃┛┻┝┬╂┠┴罫痙奎脛谿溪螢蛍渓閨憩圭携硅恵刑継勁珪計啓褻蹴毛異け姑配栩椡橡櫪椪檪椚湫箜櫟含纐柵婚屎糞癖潛潜鵠凹窪縊跟頚軛珞頸首諄鞋窟履轡覆沓碎砕条降件頽崩屑釘莖茎陸杙杭掘崛倔鶏鐃藥擽薬樟楠梳櫛串釧與与挫籖鯀鯨籤隈熊艸嚔藾叢鏈腐鎖種ξΞ臭楔草圀國邦国髭嗽漱吻嘴脣唇梔腔φ粂熏皸醺桾皹勳裙崑燻訓勲葷詳精委钁鍬咥銜桑某冥眛峅昏罔暝鮓比闇位鞍藏暗倉廚厨涅曇蜘佝栗包俥車梍枢畔鐵玄蔵黒吼桍苦區吁暮喰刳焼怐紅眩孔駒組呉瞿倶区惧口工垢衢繰酌絎劬枸窶煦懼句貢狗庫食嶇く段痍疵絆紲傷築鱚嚴稷黍帛後碪砧絹兆萌刻鞫椈掬辟君牙蘗檗訖迄狐屹詰佶拮吃鞠橘菊喫＜＞°∽▲◎≪≫≡↑∴＋≠｜△♯／−〓♂＿″∨¶▽〆：〒＠ゞ％≒∫○‖‡¢∞！‾ヽ§↓；—≧＝＼℃£゜□†・◇＆．ゝ±●。∝☆゛ー≦Å←〇＄′〃◆＃｀，÷Ц‥♭…´ヾ■仝々♀、★‐‰▼¬♪¥⌒∵¨？＾煙蚶更衣細后妃楸蕈茸乙雉轢杵軋岸桔穢汚北樵際裂燦煌雲嫌胆竏粁瓩浄潔澄淳清雰錐蛬吉霧檮桐忻饉箘噤襟鈞釿瑾磬听箟釁懃衾芹覲衿掀檎斤蒟径窘擒巾菌公禽筋錦僅欣琴均禁謹緊欽近勤踞嘘舉據筥渠苣擧秬鉅慶倨距歔遽鋸醵拠拒去洫亟蕀勗跼旭局挙許居巨虚洶竅羌頃炯竸梗繦轎蕎刧况峽竟鍄卿誑狹恟筴廾荊抂棘經烱陜徼姜襁恊況亰僵劫筺篋孝亨跫敬筐梟饗矯矜挾挟校拱嬌鞏響杏向興匈嚮享警競喬怯兄彊僑兢供莢狂橋驕兇凶郷叫侠匡狭夾恐経疆協境胸強驚脅共恭今教玖笈疚赳鬮摎扱歙蚯恷樛皀９貅舊逑邱烋岌厳胡翕朽泣穹糾糺及躬汲臼窮灸弓宮久柩究給丘求鳩級球休救旧急吸九著癸尋窺羇祺綺虧嬉机耆聴聞祈剞切麒喜規欷冀效譏訊馗麾曁効幾器跂圻期鬼匱唏气瞶憙木寄飢城櫃揆愾稘着既竒伎旡記肌氣禧危希諱驥軌熈屓剪跪噐生覬截暉喟畸碁碕倚燬利忌稀其季幃毅起鑽消嵜淇僖槻逵棋來姫酒基棊覊熹箕鰭奇棄欹企毀崎餽熙晞祁决羈聽樹饋徽徠騏朞伐黄揮妓煕来汽几斬己弃杞卉猗詭岐紀貴饑騎決極愧掎畿悸き癢糜粥痒麹輕骨業軽鰈鰔餉通瓶龜甕亀鴈獵鳫殯猟雁鳧鳬釀髢鴨側巛躱厠廁磧瓦獺翡裘皮→紮搦苧碓柄枳軆體躰躯体鴉犂烏機絡空唐榧茅揀鐶寰稈丱厂鑵歡坎篏捍卷扞撼豢皖淦歛戡驩瞰盥杆勸讙羹蒄陷瀚啣繝拑嫻罕奐羮憾骭澗潤鸛澣康樌懽嫺莟酣觀橄涵渙凵堪覡巫鉋萱簪舘艱咸翰柬駻悍燗槓浣邯稽攷宦考棺潅閂煥鉗疳癇凾函鹹顴桓款緘箝諫諌轗旱坩侃鰥　館莞橇韓患灌勧菅奸簡刊柑肝桿看緩寒干嵌廣広竿貫巻敢漢環間歓閑喊陥喚甘監寛管慣完乾艦幹官観壁椛屍姓庇鞄芳蔓鯑一勘⊃影蔭陰景＊梯棧筧庚辛柧┐┌┘門廉脚乞癩∪川合《｝‘”〈’）“｛》〉囓柁旗悴鮖舵鰍鍛梶錺餝飾篭籠孵卻歸皈還省顧楓却帰反返守督髮帋祇韮裃雷髪紙鉦矩曲予鐘樺沫偏騙語潟刀象模仇固硬傍難容忝辱頑形方旁型肩風滓微翳幽掠綛纃絣緕擦糟鎹粕蠍猾∩瞎戞轄剋蝎喝擔劼∧黠濶恰聒蛞餓鞨羯筈曷刮鬘蘰桂闊括嘗捷豁渇担滑堅鰹割戛活疽暈鵲瘡傘嵩重襲葛笠堵硴牆墻蠣蛎柿掲罹關抱踵嬶嚊拘関係貌顏郁薫顔母感窰釡罐鴎框叺構喧竃竈缶釜蒲鎌數数槝栢膳傅瑕畏賢橿姦樫炊爨喞圍託囲鈎『鉤「』」限鍵傾禿蕪鏑頭齧気被兜敵適哉必要鼎彜彝鬲叶片哀愛悲鋺蛇鉄蜩神奏楫裹磆餅徒褐糧粮幗槨壑∠膕寉狢咯覈膈貉茖擴蠖覺掴愨椁骼癨埆穫嚇隱殼霍礁恪擱匿撹攪喀廓較郭〕［【〔】］殻挌劃閣格隠覚矍革核鶴馘攫獲拡客隔角確枴醢喙价懈褂揩峡獪觧椢茴丐誨櫂誡畍匯夬廨械徊蠏隗迴恠囘嵬壞榿蛙瑰乖浬鰄傀糴柏街鳰懷蛔蠶蚕邂蟹潰壊恢腕芥垣楷會拐悔詼諧契皆疥界魁偕改繪貝胛絵甲快灰槐晦懐介解回廻階塊戒開会怪海縢篝炬赫耀輝冠鑒鑑各屈鏡痂買墟淅刈蝌茄珂稼譁彼崋駈個狩懸咬價哥醸畫下支代描翔迦糅禾藉科勝訛課換涸譌闕賀苟萪花上掛蝦个軻踝馨貨枷箇呵家画霞伽訶缺罅書何佳変価柯賈戈噛借禍菓香駆袈枯繋ヶ跏貸顆耶河嫁替遐夏架日嗅舁葭華蚊斯交火易變苅渦謌夥驅和過飼歌鹿暇黴笳嚼假窩咼搗兼寡苛渮果嘉卦厦廈靴嘩珈賭掻且仮啝克嗄欠蝸化加舸ヵ荷可堝かｋ京節└┗※хХ忽コ汗〜功（株Kク×金窯キκкΚΧケカχКk]"
;;     "[ォぉェぇゥぅィぃァぁ＜≪ｌ‾＿≦李左←⊃∨∃¬∀ル∧レラΛЛ£лλl]"
;;     "[脆醪師諸催靄舫腿銛杜森聞捫匁紋問玩翫擡齎靠凭鴃鵙縺悶樅籾椛楓蛻潛濳艾潜殯黐餠用糯餅桃者懶專専物尤勿畚旧悖戻下故許乖求礎素基本元綟捩文默沐杢黙网罔耗莽芒檬耄朦魍艨濛矇曚亡蒙毛孟猛網模持喪望洩糢楙姆揉以漏保藻貰若燃摸裳母茂も麪眄緜緬麺門棉綿面蓍珎珍♀娶貭粧妾牝瞽盲娚暈繞萌慈惠恵萠暝謎滅溟姪瞑盟酩銘鳴奴睨賞碼瑪女芽雌減召め羣榁室簇屯邨連邑叢村紫梅葎宜憤葮槿毳椋酬報尨躯骸旨難睦酷麥麦邀対百迎昔空虚鞅宗棟胸掬娘結笞鞭徒蠧蝕蠹蟲莚寧筵蓆席虫毟貉狢豸貪壻聟婿六毋鵡夢務咽剥无謀無噎群霧梦矛蒸武向牟む渠霙溝妊澪薨岑嶺峯峰亂紊淫婬妄濫猥乱■◇※＊簔穣簑蓑儖醜慘短惨幹研耳壥廛店操陵鶚岬崎巫尊詔敕勅＞」砌頻汀→】』右翠碧緑認幣蹊径倫導途通路道瞠髻鬟湖自蹼蛟瑞癸禊晦漲源鏖港湊南瞶謐櫁水調貢密甕帝蜜覩幸脉脈韭韮竓粍瓱榠螟茗名妙命冥都宮閔罠皆眠明民味箕看充観觀視美御身彌己靡盈實稔三魅診深巳壬弥み毬鞠紕蝮麿転稀賓客檀繭黛眉巡囘周防衞衛護守荳菽豆槫°゜◯圓。・．（）丸鬘謾幡縵鰻懣幔蹣蔓瞞卍饅漫滿慢迄笆貧幻瞼蔟疎眩廻回申設儲招繚統纒的蟶孫弯彎籬擬免猿亮純信実委罷侭圸壗飯儘継随髷任芻蒭耙紛鮪猯見塗學斈眦眥眼俎愛学斑斗枡鱒升舛桝萬蠱呪薪槙槇牧惑悗窗円窓甼襠区街町前複亦俣叉跨全瞬木胯股又鍖枕膜幕詣妹瑁參参眛哩迷枚米賄賂埋昧邁毎秣奉枩抹沫靺祀纏祭睫末秀大太勝柾弄優成盛將松匡鉞賢誠征希将昌政雅正仁間茉在増馬墹枉先混蒔痲俟散万雑交嘛満待摩播魔捲巻未坐負舞益目媽撒敗磨放麼真曲眞卷まｍ光月♭♪♯ム∇∽⇔≪≫∧√∂≡∴≠∈∨⊂Δ≒⊃∫∞×≧∋±∝⊆≦∪∩⊇∠÷⊥∬∃∀¬∵⌒⇒♂曼麻●〇◎○モ〒′−マ最ミメΜμМm]"
;;     "[ンん麕咒燧烽詛呪孔弼雅朔伯悳教糊宜典範矩哲紀規憲修亘允惟攵展順暢信則法後罵咽吭喉鑿蚤々湾宣曰覘臨稀望覗殘遺残鋸芒禾騰幟昇登上簷檐軒遁逸衲皇碯曩瑙王腦嚢膿能脳農嚥飲伸乗乘飮熨廼野陳除之退−呑埜延載述濃の塒姉檸侫聹嚀濘寧佞鼡鼠拗猫嫉妬希願捏熱労犒葱狙閨睡棔眠棯然稔懇拈撚燃念年袮禰煉捩捻音錬嶺涅値練根粘寝祢子寢ね絖饅垈帛幣鵺主蛻拭温布沼偸盜窃盗抽擢緯糠額抜怒貫縫奴塗脱濡拔ぬ楡蒻潦鷄鶏瀑庭繞獰女尿眈韭薤睨韮姙儿刄蒜葫刃忍∀妊認任人乳擔蜷担濁賑握俄鳰臭匂錵沸贄偐僞贋偽柔靤如苦膠霓滲虹躙廿《》◎∬『』悪憎兄螺鰊鯡錦西入新肉‖貮仁煮貳迩丹似弐2邇尼荷二２弍児岻逃迯に靡抔嫐嬲鯆屶釶鉈泥薺詰若慨歎嘆抛擲撲毆殴慰治癒等猶直泪波辺邊邉鍋浪某棘棗懷懐夏擦梨情譌懶艶訛鉛鯰癜鮠鱠膾韲憖怠鈍腥捺准擬凖準謎涙洋宥傾灘詠霖眺痼存乍流轅永和椥梛渚長勿莫毋半・媒仲中７斜七蔑乃尚内繩畷縄苗滑鞣惱悩哉就也斉形業徳娚垂喃∵楠尓爾汝男軟難何双柞枹列均倣肄⊃→⇒楢習納啾做娜熟那慣鳴南奈狎綯痿無茄嘗失並馴啼撫生泣嚶爲菜薙舐拿凪亡哭萎涕投為魚儺竝な┘┛┃│┨┥┤┫┝┠├┣╋┿┼╂成＃∋∇名└┗ｎ日≒ニネ〜¬≠ナヌノнΝνНn]"
;;     "[俺游泳指妖畢在澱檻氈拇親愚疎颪卸念錘惟慮赴徐趣俤羈主想表重面園隱瘟Å怨♀妾温恩鈍悍臣覺溺朦朧思覚榲現朮桶威嚇踴戯縅棘愕駭驚躍踊傲奢驕嚴厳遣痴瘧怒行怠蒹補荻懼獺惧怐虞畏恐襲甥笈及綬葹〃ゝ仝ヽヾゞ々同唖繦襁鴛鴦教几忍筬收兎抑稚長幼理治収修檍遲納後遅賻饋諡贈送憶袵臆拜拝奇峻阜冒犯岳陵崗侵女陸丘岡欄斧自己各戦鬼衰劣囮頤訪貶乙漢♂音弟阿脅怯首夥誘屋膃億穩穏煽熈煕燠熾諚掟興隠沖墺蓊悒殃泱姶毆瓮嚶翁罌枉徃閘浤惶襖鴬凰泓奧秧澳鸚懊嫗媼鴎怏鏖謳旺凹櫻鴨欒楝樗殴朷甌汪横往鞅歐嘔陥陷遠蔽夛奄應果掩蓋応概欧公邑麋薤被仰扇皇狼弁鴻鳳鵬黄奥多衽覆粱凡鰲頁王降於置押尾帶汚起追捺塢朗惜御小麻織措夫緒苧折男勇帯負央老桜嗚推圧穂墮牡淤悪生郎壓墜下終乎落擱雄堕怖唹逐居将おｏ大◎∞和∝♪∨∪開Οオω○ОοоΩo]"
;;     "[本磅椪砲烹方法報歩舖舗ぽ蔽併閉閇×邊辺篇片邉編遍屁ぺ服幅風分腐布符泌匹俵憑票品筒平日犯搬版板幇払腹発發走箱朴愽拍博駮泊包放敗配牌杯盃八破羽波張播ぱｐ鉛ψΨぴ±＋ぷφΦ┣├∝北┴‰．％£〒・点プポ頁）（∂¶‖ペパПпπΠ燐ピp]"
;;     "[配栩椡椢橡櫪椪檪椚湫櫟含纐柵婚屎糞癖潛潜鵠裹凹窪馘括縊跟踵頚軛珞頸首諄鞋窟履寛狐轡覆靴沓碎砕管条降件頽崩屑葛釘莖茎陸杙株杭掘崛倔鶏鐃藥擽薬樟楠酒髪梳櫛串釧與与挫籖鯀鯨鬮籤隈熊艸嚔藾叢鏈腐鎖種ξΞ臭日茸菌楔草圀國邦国髭嗽漱吻嘴喙脣唇蛇梔劫腔φ刧　空粂熏皸醺桾皹勳裙下薫燻訓勲葷君詳精委钁企鍬加咥銜桑塊某晦冥眛競峅昏罔暝鮓比較闇位鞍藏暗倉廚厨涅〃ゝヾゞ々仝ヽ曇雲蜘栗狂包俥車廓曲郭梍枢踝畔鉄鐵★●■玄蔵黒悔来吼駆桍苦徠功驅區吁暮喰刳久焼怐紅眩孔駒宮組呉瞿奇供倶区來鳩惧駈口工垢衢朽拘矩繰九玖酌汲絎劬枸窶煦懼句貢狗柧９躯鉤庫屈食嶇くｑ‘”’“♪ケ？ク¶q]"
;;     "[堽侖崙崘栄論漉祿轆碌肋勒麓禄鹿６録瑯蘢榔薐鑞瓏僂實螻潦焜樓勞臈滝簍朖螂琅弄柆槞哢咾隴朧壟撈臘郎瘻廊牢浪蝋癆聾篭楼籠狼漏朗枦髏輅櫓艪蘆顱櫚艫櫨臚廬炉轤驢瀘爐鷺蕗滷賂鹵ろ洌糲〇蛎苓綟澪囹犁儷砺齡蛉鴒齢蠡唳聆勵黎羚戻禮祈隸茘隷麗玲伶癘励零冷例冽劣烈裂列靂轣鬲癧櫪檪瀝礫轢歴縺鏈濂鎌瀲奩斂嗹匳漣戀輦簾櫺∧聨憐恋蓮煉錬攣練聯廉連れ♪路盧泪縲壘瘰誄涙羸塁累類婁縷陋鏤璢褸屡る犂篥葎率慄栗淕勠六戮陸律擽畧暦掠略畄瘤瀏鏐旒霤瑠餾窿鉚苙嶐澑嚠笠榴溜硫琉留立柳粒劉隆流棆藺廩醂麟鄰痳菻鈴懍P躪躙淪厘凜霖琳悋綸淋禀稟凛鱗倫吝隣林燐臨梠絽侶踉膂虜呂慮仂力緑鐐暸繆楞魎嶺崚輌怜粱凉椋鷯靈獵鬣裲倆粮兩廖蓼輛燎瞭聊陵令梁糧諒霊遼龍凌漁亮寮涼⇔繚撩綾療竜量菱僚領喨了寥稜両料閭旅李理莅履痢利釐哩裏詈驪漓浬梨俐籬里罹璃吏離俚裡莉悧りΛλ婪襴覧亂臠覽儖欖攬瀾嬾籃繿纜巒檻欒襤懶爛藍鸞卵濫闌嵐欄乱蘭労溂剌老埓埒猟辣薤喇樂珞絡犖駱酪烙楽落洛徠罍擂蕾賚醴耒籟儡櫑莱磊癩來礼雷頼来拉裸良等們騾蘿鑼邏螺らｒ右→УпгОьЙлГъВдшЦэЖЬТЁяЕыютзчНкБЗИхоеСнмЛПЫЪЩЧ露АцФЮХуШёаифЯЭбКжй魯МсщвД輪√根羅ロ々ラルレリрΡРρr]"
;;     "[似杣灌傍峙毓育具供備害底苑薗園酘貮儲妬埆埣譏讒詆誹謗濡外猝率喞熄仄息足促束測側薮歃掫甑髞湊嫂窗弉鯵帚槽赱叟笊滝嗾裝葱壯搶譟蚤嗽懆筝燥剏崢贈瀧澡竃愡爭樔勦瘡屮雙蔟艚奘菷諍箒竈抓梍艘偬輳箱孀窓踪匝噪遭艙爪糟莊倉匆怱曹淙繰宋漕簇槍躁鎗箏綜痩喪藻艸葬壮操掻掃奏蹌滄争草層創蒼叢僧走惣送叛乖抑諳某轌橇艝巽拵邨鱒噂忖蹲樽孫遜存尊損反詛疏踈徂逸噌鼡麁祖副咀阻胙愬粗俎齟爼沿甦鼠訴礎措租祚想塑蔬其蘓姐囎組疽沮疎酥そ芹鬩鐫揃喘燹韆綫栫痊巛槫涎吮僣潛筌纖舛專簽刋倩舩旃槧苫亘沾饌湶濳仟阡箭籤茜荐筅錢擶纎磚孱翦濺氈甎僊癬蟾籖銛孅牋羶箋贍殲殱闡釧賎餞羨顫甅竰糎¢陝銓踐閃潺遷銑栴川剪煽譫僉瞻践栓跣疝詮銭穿戰繊僭腺泉嬋淺擅鮮専潜扇浅船蘚線撰宣洗煎戦千忙倅伜逼蝉旋緤泄絏屑椄卩洩紲薛攝鱈褻浙竊℃窃拙摂接節楔淅籍瘠迹蹐蹠藉威績裼蓆跖磧晢關勣晰跡夕鶺潟碩惜析関隻席萋菁躋嘶撕擠婿睛韲牲甥貰晟情穽筬齏瀞淒掣腥逝惺旌蜻整靖誓制晴畝攻勢丗畆急世競脊堰糶瀬せ鯣鋭坐座李已既昴術辷全滑皇脛臑裾双英村選優営寸啌雪勸濯漱薦啜勧芒薄煤賺鼈捩筋頗輔甫丞佑亮祐介助蘇裔陶曽曾乃即則淳漁凉鑾篶漫硯雀涼鱸鮓鮨遊椙犂耒犁篦隙尽末眇縋管菅廢頽廃窘救掬寡尠粭糘菫速純鈴炭角墨隅【】陬鄒菘雛數芻嵩崇趨樞±≫∫∧×∝∃∞∂∬∇÷≒⇔≪Δ∨≧∠⌒∩∵∋⇒∴¬∀∈≠枢錘隹捶悴榱萃粹騅陲瘁翆邃忰帥誰醉遂膵燧彗綏錐穂炊翠⊥H吹粋推水酔睡過掏剥籔醋喫好壽澂直漉棄空拗擂簾住巣栖饐耡鋤梳棲吸総透總剃寿統据磨澄埀謐蘂蕋蕊痺茵褥鵐蔀鷸鴫入霑蔵嶌縞嶋島凋澀沫澁渋縛暫屡荵凌鎬忍簧舖慕↓襪健認从啝從随．舌扱罔Θθ虐粃秕椎椣卓貎尿臠肉猪榻黙蜆楙誠茂成繁重惻鋪陣頻閾櫁樒鹽汐潮隰瑟蟋櫛嫉隲疾蛭漆躾膝失室沒鎭沈滴雫賤鎮靜顰尓爾確聢併◆◇鹿貭叱征質卯滋撓科品鬼鍜錏錣凝痼而拉設萎栞襞吝咳爲什導怪汁験徴著記印〇○』銀城代『報調蝨濕湿七僕笞楚霜臀退斥尻寫柘卸冩者舍炙暹諜喋煮這謝鯱奢赦捨瀉釋蜥決蹟刳嚼鑠妁斫勺抉爍皙昔芍酌爵折癪笏赤綽灼石尺借赭写鷓積舎車斜釈社娵麈娶株蛛諏洙殳鬚侏繻銖卒粥戚槭倏肅菽蓿蹙叔俶淑夙粛縮取殊珠趣卆恤蟀出繍溲遒讐洲綉駲讎楢逎酬楸穐鷲緝蹤岫萩甃嗅泅楫螽葺售鰍收驟舅囚姑蓚鞦脩輯醜習羞酋聚舟秀祝袖拾啾蒐収執衆愁襲就臭蹴週終褶州宗椶棕守朱撞種修周手首狩須雋皴蕣悛儁惷墫順蠢舜旬竣峻駿逡春筍瞬俊岑臻寢槙脣娠譖鷆晉忱齔嗔袗怎簪蔘哂蓁矧譛鷏疹畛甄縉瀋箴軫榛秦襯診鉐津駸讖紳斟針唇呻蜃賑芯瞋振殿侵辛晨薪辰震宸森眞愼伸慎寝晋身進審深親臣鍼心宍信神薯嶼杵苴處苜墅且砠藷狙胥岨黍蜍渚曙背塩緒枌雎蔗庶処所書暑聲稍艢鷦橸劭礁厰舂將腫政嶂蛸枩廂懾嘗韶峭邵奬炒慯筱摺鬆顳樅星樵訟梢敞橡霎廠秤燮愴愀姓甞湫獎井觴鍬剿妝餉庠浹簫陞殤淞誚升璋醤慫従逍倡竦爿墻牆薔笙樟装肖菖＜≦湘誦聳檣稱声裳（）蒋蕉嘯慴精霄鈔粧鏘悚悄蕭彰哨瀟焦憔匠鍾償瘴漿頌詔妾沼請衝唱薑庄渉奨床牀娼椒鉦宵抄荘翔傷踵召銷賞猩症昭燒猖尚昌少憧松晶紹捷象承正證笑勝称焼将照招詳章消鐘硝証掌省商昇屬謖寔餝稙軾昃矚稷拭嗇穡禝属燭贖色飾囑嘱織蝕式喰蜀殖諸初埴植食職賜閇柿阯咫仔駟伺摯之鷙染肆祇凍至嗤翅錙祉釶巳笶浸紙肢脂貲尸篩諡司四蚩緊祗姉糸粢氏侈厶厮思贄閉嘴帋弑屍為熾滲若髭敷啻此師梔耆絲痣次誌歯恃茨及舐沁緇諮獅駛飼試俟嗣趾志示如咨砥識笥斯滓幟岐揣呰詞自弛漬梓始矢卮姿紫芝詩史瓷廝輜使絞齎施時締旨屎巵資孜址只覗齒恣徙誣豕泗耜死觜妛茲祠枝占竢視市痴領子祀雌強沚謚し杓雨寤鮫清鞘莢騷觸触鰆椹爽騒澤沢濬掠新攫渫浚杷更士桾申素白嶄纉餐粲汕蠶跚衫讚慘驂攅鑚芟爨斬蒜潸戔彡杉秋桑…≡簒纂鯢燦珊繖棧刪卅參鑽蚕算傘３▽贊▼3参賛O散惨産酸嘸摩遉樣彷碍妨様山漣貶蔑垂鮭叫仙寞寥皺鏥淋生鯆虱鯖捌偖扨偵宿禎貞定哘誘蝎蠍授皿祥桟匙簓障囁私篠支捧笹逧迫讃鐸蛹宛真碕尖嵜前崎魁峺遮哢囀候侍核実俚説暁了逹達聰敏諭慧叡訓哲知郷悟智聡恵理杆里小棹竿扎紮箚刹皐撮搜寒捜相主盛柧觚盞盃杯榮栄倒肴魚阪界堺境酒泝逆賢坂榊猿麾挟鷺拶撒擦颯先数察薩刷札摧崔釵腮悽凄切責淬縡纔衰綵晒霽砦樶寨洒靫顋濟殺灑碎偲犲哉倖豺呵苛幸猜塞蔡栽儕采財齊臍截孥載宰済齋犀際災柴賽菜砕採債妻斉祭斎催才細鰓裁歳最埼槊筰筴柞齪縒捉册咋辟簀窄酢嘖朔柵遡溯鑿索搾昨炸冊策錯櫻桜削詐曝插査寂避嵯瑣止狹做渣再沙蓑嵳注娑去柤早射捺醒瑳扠冷槎嗄佐挫咲砂些左紗搓作褪莎簑銹錆覚挿割茶冱覺差磋梭冴提下裟点狭唆嗟刺叉裂鎖然螫蹉荒乍さ√錫す／仕指製西　┐┓〆□■Шш上♯＃щЩ添∪日ｓ⊂⊆⊃⊇文静＊★☆標嗜青三聖土彩▲△悉署〜∽‘’┌┏集＼探§″性セサシソスс秒ΣσСs]"
;;     "[乕囚寅虎瀞舮靹侶供纜燭艫朋倶鞆讐讎輩伴共友巴飩沌惇丼団暾團遯燉遁豚禽鷄酉砦塞俘擒虜豐恍惚枢乏塒迚科咎篷笘攴苫鶏伽唱稱鄰隣朿棘刺整鎖處処所床享鵄鴟扉鳶嫁訥晨刻穐秋鴇鬨斎頓幄幃帷柮杤栃閼軣轟屆届咄吶凸駿暁祀世壽繁稔寿豊歳俊利敏年悳慝黷牘犢匿督徳涜∃得特萄盪夲沓鬥儻檮陦帑滕蘯酘吋稻兜叨櫂亠棹嶝縢竇篤淌樋涛礑擣鞳桶朸荅閙讀罩磴纛棠剳納鐙溏搨迯宕抖諮籘榻梼嶋潼鬧嶌道釖塘盜橦档黨綯鞜逗螳蟷稲■幢滔鼕掏當峠読饕疼淘濤籐董悼棟搭痘套＝燈豆桃韜統遠騰橈冬討骰祷藤灯島橙凍刀陶糖謄唐答投等桐泊解秉留砥止畄蠹録図礪鎔肚蚪獲賭十渡妬菟人外莵翔閇疾問富荼執屠砿研採途取冨梳鍍覩觧戸砺熔兎睹溶蠧登杜穫塗融説飛跿脱圖摂堵盗汢磨兔と瑛晃輝衒寺鷆諂腆壥碾殄、槙，躔鷏廛囀巓忝靦沾霑轉：‥．輾填甜奠顛纒癲恬殿纏覘展篆添梃輦輟姪垤銕咥耋屮餮鐡跌迭荻鏑狄廸笛俶糴逖覿擲迪滴轍的哲敵撤剔徹鐵鉄嚏楴酲騁鵜酊叮碵嚔柢睇眤詆棣羝掟遉觝汀釘幀渟弟碇剃蹄邸締梯悌訂程底偵廷遞逓牴抵呈艇鄭涕啼庭定低弖照て模幹劈聾辛列貫面液汁露冷舶錘紡系艷艶鉉寉絃橡劔劍剱釼劒剣弦蔓敦鶴幣兵鉗噤鶫償恆桓典恒常夙勉務努勤拙拐抓倹嬬撮詳審爪褄妻募角晦瞑螺円呟礫具粒辻辟罪把捉捕閊寮丘阜首曹元司官柄仕掴遣攫搏疲使窄蕾莟局壷壺坪綱繋壌蝪培霾戊己伝傳鐔翼翅鍔燕唾續約皷鼓続葛綴番栂槌縋弊費序潰終墜遂鎚椎追殲捏殱做繕傍旁創造作熟机佃蹲坏拒欟鴾槻月障砲裹躑榴謹慎筒恙愼包堤痛接憑附継繼盡支連浸尽就告付通攣次積嗣點突漬衝椄詰尾撞搗津つ吃釁衢岐巷粡粽因杠契鵆児交腟帙膣些蟄N窒斉秩父捷矗筑築逐盟税力親邇誓迩近苣尖縮鏤塵趁珎抻亭狆朕鎭碪跛闖鴆砧椿枕鎮陳珍沈賃杖找摘茶嫡着儲瀦潴箸竚杼躇紵豬墸苧緒樗楮⊥陟敕飭捗躅稙猪勅著窕萇微鵈迢挺趙佻蔦輒髫誂塚昶廳脹廰糶楪膓吊鼎悵疔樢澂輙聽齠晁甼雕鬯漲凋帖掉停諜跳眺貼鐇澄提喋頭銚ー蝶暢帳丁牒重逃鳥弔張懲肇兆嘲徴釣聴彫潮頂町調貂腸庁超挑朝丶黜紬綢惆肘籌蟲冢丑晝儔冑※胄鍮寵廚稠酎紐鑄冲沖偸宙虫］｝［｛厨誅鋳紂仲註駐注柱衷籀昼抽中痴池黐血置黹褫岻稚輊癡致穉夂遅散馳千知笞蜘乳踟家治値躓魑耻禿茅恥地智夊緻薙遲ち便党屯榱椽架樽弛鰔膤蕩鱈盥戯俵袂保躊為様樣爲疸餤緞摶毯椴湍亶褝殫檀膽彖覃站啗鄲袒綻攤慱潭憺襌猯壇憚擔槫賺靼酖湯澹‡†蛋耽W痰旦啖坦眈反C嘆歎誕胆箪譚担淡鍛單短探貪単覊栲妙戲訊攜携尋訪比畴疇類民髱樂娯恃頼愉楽喩例譬滾激嵶仆斃垰殕倒嫋旅貍狸称讃賛敲蹈踏祟湛戰鬪斗戦闘彳佇叩疉疂疊畳箍鏨違互耕畉畊掌店棚到炭辿斬撻韃闥燵巽辰佐扶援＋佑相弼輔助襷髻椨誑胤種塔龍竜糜糺爛漂維伊禎貞理直惟是忠匡徒唯只窘嗜慥確胝鮹鱆凧蛸誥嶽哮茸豪英威毅猛笋筍酣雄丈健斌武彈靈珪承賚珠魂霊卵偶適環弾球玉丹謀莨束縱｜盾鬣奉楯蓼縦竪質城達館忽橘舘瀑薪滝瀧峪溪渓谿谷宇亨集任臣尭昂楼小剛洪恭岳喬嵩孚尚孝尊敬崇隆貴鷹竹篁簟寶財高寳宝但濯柝擇拆鈬擢澤綰魄柘啅倬戳鐸畜企啄磔巧匠択沢逞琢蓄度託宅卓謫托拓躰紿碓隶抬黛體滯殆靆帶替軆平駘擡逮腿当怠玳諦岱鯛對颱袋戴堆頽態苔滞待代帝貸隊褪胎帯体泰大退対夛経佗經溜揉建侘他蛇炊手發矯朶強起耐発勃薫它絶咤埀田堪詑闌給詫躱裁截賜撓断点立貯長多太岔逹斷汰焚垂足食誰閉澑たｔцЦ〜天時×型火土→吐都東上瓲噸│┃台表第木スジ∴Θθザ正ツ¨転透▼▽△▲トチ…・試端タΤ┴┨┤┥┸т┝┰〒Т┳τ┷┠┻テ┫├┬┯┣t]"
;;     "[孳蛤礼敬恭洞鱗愛潤騒煩粳漆閏患慯悄恙騷愁呻楳梅嫐釉噂吽曇褞黄紜耘云繧慍薀蘊暈運錙怏麗羨卦憾怨恨占卜末嬉心裏浦糶瓜汝己畴畦畆疇畝疎踈宜諾奪姥腕莵兔驢鑿穿嗽魘唸促令項頷訴獺鷽嘯嘘蠕蠢動覘窺伺海萼台詠謌唱唄宴讌転詩謠謡謳疑歌葎鯏鴬鶯ヱゑゐヰ鶉疼堆蹲踞渦舂臼碓羅薄食筌槽朮肯凵魚巧茨廐廏厩鰻午甘秣孫餞馬旨冩暎遷蔚寫噐器移慈俯映写現虚美靱笂靭靫空鰾萍初蛆雲氏上後喪艮丑潮牛裡鬱中欝袿梁家内雨菟有射胡得埋挧傴産受烏憂饂右打禹績搏泛鵜紆迂撲夘請芋熟承膿享攵浮卯賣齲宇飢兎攴羽失于売撃植生討茹嫗盂倦うｕ¨↑∪υΥУуウUu]"
;;     "[ｖ：├値⊥版В∨вヴ↓v]"
;;     "[ヲ女翁汚尾緒男惜小牡雄を孳蛤礼敬恭洞鱗愛潤騒粳漆閏慯悄恙騷愁呻楳梅嫐釉噂吽曇褞紜耘云繧慍薀蘊暈運錙怏麗羨U卦憾怨恨占卜末嬉心裏浦糶瓜汝己Υυ畴畦畆疇畝疎踈宜諾奪姥莵兔驢鑿穿嗽魘唸促令項頷訴獺鷽嘯嘘蠕蠢動覘窺伺萼台詠謌唱唄宴讌転詩謠謡謳疑歌葎鯏鴬鶯ヱゑ鶉疼堆蹲踞渦舂臼碓羅薄食筌槽朮肯凵魚巧茨廐廏厩鰻午甘秣孫餞馬旨冩暎遷蔚寫噐器移慈俯映写現虚美靱笂靭靫空鰾萍初蛆氏↑上後喪艮丑潮牛裡鬱中欝袿梁家内雨菟有射胡得埋挧傴産受烏憂饂右打禹績搏泛鵜紆迂撲夘請芋熟承膿享攵浮卯賣齲宇飢兎攴失于売撃植生討茹嫗盂倦うヰ居ゐ叫喚÷惡悪稿原嗤妾蕨童藁鞋笑萬豌綰灣万弯彎椀雲腕碗湾黄往横皇羂罠纔微毫僅煩患術伎厄災禍態業技佗王鰐忘掖弁腋譯腸緜道渉亙弥航亘棉渡綿私隈薈賄淮脇矮猥歪轍海蟠儂∪頒觧解判訣別稚若或枠惑鷲萵破話羽割詫訳杷琶倭我和侘吾環把輪涌啝湧分沸わｗ幅水∧波ウワw]"
;;     "[ォぉェぇゥぅィぃァぁｘХхξ×Ξx]"
;;     "[蒿艾蓬娵嫁齡齢據頼弱憙歓鎧万萬過便婚汚涎捩杙翊緘峪慾欲翌翼抑米比粧裝装澱淀縦誼祥葭悦克純宜圭禎葦慶淑美禧芳喜吉義窰廱癰樣榕瑶癢蓉雍泱瘍謠穃恙暘漾痒孕甬慵遙曄燿瀁踴怏慂姚珱昜陶踊幺鷹瓔煬邀遥拗擁瑤窯徭窈膺殀耀曜庸夭揚葉蛹腰羊熔杳沃壅様妖溶用佯謡陽洋嘉宵蘓蘇甦奸辟横選醉訓輿四能丗予与歟代譱預憑除詠呼読讀飫４餘避撚畭與縒蕷舁譽豫誉喚攀酔世余よ潤赦弛緩聴岼閖梦努纈∴故濯檠穰豐豊倖志裄之幸雪趾梼讓譲牀紫縁浴床犹莠邑俑酉熊猷尢蚰悒黝囿蝣蕕攸佳尤佑〒右郵涌侑祐游猶湧融宥夕幽悠釉友雄憂有兪覦腴楡徃輸愉喩蝓揄結弓臾諭由瑜逾瘉柚汰搖遊諛淘油渝征茹揺踰揃ゆΗη賤卑鄙苟嫌妹湯芋藷夢艷鑪鈩彩鱗色鯆忽綺貸甍応答愈圦杁蚓茵霪婬飮蔭贇酳韵寅尹胤隱氤湮堙吋廴I音慇韻咽淫殞姻隕院允殷隠陰窟巌巖頌祝鰛鰮鰯岩磐鼾歪弋弑抱懐贅肬疣狗戌乾犬諱坐在未汝誡警戒縛今Εε曰禾稻員因蝗印嘶鰍電引躄誘動忿≦鵤錨碇怒雷霹霆凧桴筏Ιι魚菴庵雖尿荊棘茨祈祷命猯豕古聿鎰乙鴪伍軼樹慈悼慯愴労格到至傷鼬頂戴徒致鈑痛板柞砂沙些聊潔諍烈功諫勳勇勲漁諌憇＝憩粹熱粋憤域閾勢勤忙急磯孰焉湶泉厳何弄苛≧范鎔啀毬訝燻息指挑拠絲縷厭營営愛幼緒遑暇糸Ｉ弌壹肆莓苺櫟著市碑鐓礎甃臀弩石犧犠牲池溢佚壱1１粥毓鬻燠礇的戦戰軍郁幾一稲許否飯揖詑居入維将洟挿容良行緯活矮渭慰逸往爲唯斐饐炒生凍頤出威胃矣姨要肄謂僞委云為五萎煎蔚鑄井恚位懿醫貽好以ゐ噫怡依畏違熬莞斎鋳如夷移亥帷胆圍彝彜淹痍猗椅逝鰄異熨囗善去忌倚惟癒偉堰遺偽医射幃鮪率可韋意痿猪衣逶囲李言詒彙伊苡い稚稍飲鎗槍鑓孀鰥寡Я碼傭雇闇敗吝薮藪殕脂寄宿櫓軈軅簗梁S漸鋏刃灸軟和柔窶鱧奴僕萢優柳喧宅舘館族輩鏃鑰譯籥龠葯蜴≒藥繹檪扼益厄疫躍約役訳薬岾疚疾楊谺邪薯豺犲〈《〉》山邸廛壥豢養社鑢育尉廉寧裕泰恭易休康保安靖哉彌矢耶病殺辭辞屋輻夜止已焼罷妬⇒也痩谷八灼燒熄冶笶弥瘠椰野破爺⇔揶演埜遣家やｙЕе¥円←↑↓→Ёё━─ユヤヨйイυыΥYЫЙy]"
;;     "[空損存揃薗園底束續屬足∋∈賊続粟族俗属梍賍臧臟噌僧慥贓憎像臓贈象増造添沿曽反初曾ぞ苒繕然譱禪薇千蠕∀髯禅善漸冉前全關関蝉膳錢銭絶噬説勢筮贅脆税攻責是ぜ狡詰桷寸喘鮨附◆惴蕊蘂蕋髓膸隧隋隨瑞髄随豆好図酢頭津厨刷廚逗鶴付圖ず塩縞嶋嶌島橲衄竺宍衂舳忸軸舌祖喰食直凝日實昵印闍者鮭邪蛇麝着鉐尺惹搦雀寂若弱尻贐潯糂盡仭進稔刄臣恁仞儘侭訊俥蕁迅刃靱荏甚靭燼櫁樒塵尽尋陣腎壬人洳杼莇蜍敍汝恕茹耡敘舒縟辱褥蓐溽所抒鋤徐絮叙序助嬲聶星絛茸孃瀞仍乘躡拯讓仗疉滌帖繩遶諚疊塲靜淨繞疂蕘壌釀驤穰禳襄壤生蟐如醤剩娘嬢錠静醸縄女尉饒丈成烝嫋穣擾丞杖場條条蒸貞状攘剰畳冗定浄乗情城上常譲愀鷲嬬得戍竪咒就讐懦讎濡聚詢凖隼盾筍徇笋楯篤蓴惇淳洵閏恂諄馴旬荀潤醇巡循遵順准殉純準襦誦需戌朮孰宿塾珠熟恤術述呪孺豎儒綬樹受授壽澁廿糅縱澀从鞣從狃揉戎拾中蹂神汁獸絨縦渋柔什充十従獣住銃重膩時侍孳兒二珥只冶餌邇茲怩死持子祀蒔嗣痔辞辭畤轜寺示亊弍自瓷史岻児以焦塒峙事敷治路爾次慈寿滋粫耳知恃仕似至尓爺染字地磁除而柱仁士司璽迩じ騒沢澤猿笊皿晒曝鮫鏨竄慘懴参山算殘塹巉懺嶄讒惨暫慚慙斬残実笹酒坂盛三嵜崎桜榴襍雜棹竿雑西斉済濟才戝劑剤材財罪在蔵坐戯座左咲挫冷醒差冴覚藏裂ざｚ→↑ЪъьЬ↓←Жжズゾ零〇〒ザジΖзζゼЗz]"

;;   ))
;; ;; (global-set-key (kbd "C-:") 'ace-jump-char-mode)
;; (ace-pinyin-global-mode 1)
;; (global-set-key (kbd "C-M-o") 'ace-pinyin-jump-char)

;;=============================================
;; 6. Input Support
;;=============================================
;;----------------------------------------------
;; 6.2 redo+
;;----------------------------------------------
(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t) ; 過去のundoがredoされないようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)


;;----------------------------------------------
;; hippie-exp-ext
;;----------------------------------------------
(require 'hippie-exp-ext)
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(global-set-key (kbd "H-i") 'hippie-expand-dabbrev-limited-chars)
(global-set-key (kbd "M-/") 'hippie-expand-file-name)

;;----------------------------------------------
;; kill-line and delete indent
;;http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part16
;;----------------------------------------------
(defadvice kill-line (before kill-line-and-fixup activate)
  (when (and (not (bolp)) (eolp))
    (forward-char)
    (fixup-whitespace)
    (backward-char)))

;;=============================================
;; 14. Create Documents
;;=============================================
(require 'org)
(add-hook 'org-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))
;;----------------------------------------------
;; org-mode keybind
;;----------------------------------------------
(define-key org-mode-map (kbd "<C-tab>") 'elscreen-next)
(define-key org-mode-map (kbd "<C-S-tab>")'elscreen-previous)
(define-key org-mode-map (kbd "C-'")'helm-elscreen)
(define-key org-mode-map (kbd "C-M-t") 'elscreen-kill)
;; (define-key org-mode-map (kbd "C-M-i") 'company-complete)
(define-key org-mode-map (kbd "C-M-i") 'helm-dabbrev)
(define-key org-mode-map (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))

;;----------------------
;; 14.2
;;----------------------
(require 'org)
(defun org-insert-upheading (arg)
  (interactive "P")
  (org-insert-heading arg)
  (cond ((org-on-heading-p) (org-do-promote))
        ((org-at-item-p) (org-indent-item -1 ))))
(defun org-insert-heading-dwim (arg)
  (interactive "p")
  (case arg
    (4  (org-insert-subheading nil))
    (16 (org-insert-upheading nil))
    (t  (org-insert-heading nil))))
(define-key org-mode-map (kbd "<C-return>") 'org-insert-heading-dwim)


;;===================================================================
;; 15. Helm & Anything
;;===================================================================
;;----------------------------------------------
;; helm keybind
;;----------------------------------------------
(define-key global-map (kbd "C-;") 'helm-for-files);
(define-key global-map (kbd "C-x C-x") 'helm-M-x)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (zenburn-theme use-package helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;;=============================================
;; Manipulating Frame and Window
;;=============================================
;;----------------------------------
;; elscreen
;;----------------------------------
(require 'elscreen)

;;; プレフィクスキーはC-z
(setq elscreen-prefix-key (kbd "C-'"))
(elscreen-start)
;;; タブの先頭に[X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;; header-lineの先頭に[<->]を表示しない
(setq elscreen-tab-display-control nil)
;;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
(setq elscreen-buffer-to-nickname-alist
      '(("^dired-mode$" .
         (lambda ()
           (format "Dired(%s)" dired-directory)))
        ("^Info-mode$" .
         (lambda ()
           (format "Info(%s)" (file-name-nondirectory Info-current-file))))
        ("^mew-draft-mode$" .
         (lambda ()
           (format "Mew(%s)" (buffer-name (current-buffer)))))
        ("^mew-" . "Mew")
        ("^irchat-" . "IRChat")
        ("^liece-" . "Liece")
        ("^lookup-" . "Lookup")))
(setq elscreen-mode-to-nickname-alist
      '(("[Ss]hell" . "shell")
        ("compilation" . "compile")
        ("-telnet" . "telnet")
        ("dict" . "OnlineDict")
        ("*WL:Message*" . "Wanderlust")))

;; タブ移動を簡単に
;; (define-key global-map (kbd "M-t") 'elscreen-next)

;;----------------------------------------------
;; elscreen keybind
;;http://qiita.com/saku/items/6ef40a0bbaadb2cffbce
;;http://blog.iss.ms/2010/02/25/121855
;;http://d.hatena.ne.jp/kobapan/20090429/1259971276
;;http://sleepboy-zzz.blogspot.co.uk/2012/11/emacs.html
;;----------------------------------------------
(define-key global-map (kbd "M-t") 'elscreen-create)
(define-key global-map (kbd "M-T") 'elscreen-clone)
(define-key global-map (kbd "<C-tab>") 'elscreen-next)
(define-key global-map (kbd "<C-S-tab>")'elscreen-previous)
(define-key global-map (kbd "C-M-t") 'elscreen-kill)
;;----------------------------------------------
;; helm-elscreen kenbind
;;----------------------------------------------
(define-key global-map (kbd "C-'") 'helm-elscreen)

;;----------------------------------------------
;; elscreen resume the last buffer on kill buffer
;; http://qiita.com/fujimisakari/items/d7f1b904de11dcb018c3
;;----------------------------------------------
;; 直近バッファ選定時の無視リスト
(defvar elscreen-ignore-buffer-list
  '("*scratch*" "*Backtrace*" "*Colors*" "*Faces*" "*Compile-Log*" "*Packages*" "*vc-" "*Minibuf-" "*Messages" "*WL:Message"))
;; elscreen用バッファ削除
(defun kill-buffer-for-elscreen ()
  (interactive)
  (kill-buffer)
  (let* ((next-buffer nil)
         (re (regexp-opt elscreen-ignore-buffer-list))
         (next-buffer-list (mapcar (lambda (buf)
                                     (let ((name (buffer-name buf)))
                                       (when (not (string-match re name))
                                         name)))
                                   (buffer-list))))
    (dolist (buf next-buffer-list)
      (if (equal next-buffer nil)
          (setq next-buffer buf)))
    (switch-to-buffer next-buffer)))
(global-set-key (kbd "C-x k") 'kill-buffer-for-elscreen)             ; カレントバッファを閉じる
