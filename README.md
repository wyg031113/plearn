## 本书是能过Latex写成
### latex版本：
- texlive: texlive2019-20190410.iso
- 文本编译器：texstudio-2.12.16-win-qt5
- 安装过程参照了:https://www.jianshu.com/p/8f8da0517a31

### texstudio设置：
- 代码高亮 必须在编译命令后面加上 -shell-escape; 在options->Configure TexStudio->command
- build选项用xelatex: options->Configure TexStudio->build->Default Compiler->Xelatex
- pdf默认打开：options->Configure TexStudio->build->PDF Viewer->External PDF Viewer
