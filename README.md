# EchoPulse

基于 SwiftUI 构建的极简主义、现代化节拍器应用，使用 AVFoundation 音频引擎 。使用 WWDC25、24 相关新 API 搭建，仅支持 iOS 18+ 。

## 功能特点

- **高精度节拍器**：精确 BPM 控制（40-240 BPM），直观的圆形进度条显示
- **音效系统**：多种节拍音效选择，声音切片整合技术确保精确同步
- **音量控制**：独立于系统的应用内音量调节，直观进度条显示
- **后台播放**：锁屏或使用其他应用时持续保持节拍
- **页面设计**：美观 UI，支持夜间模式切换
- **特色组件**：圆形滑动器(CircleSilder)、自定义加减(CircleStepper)、颜色渐变动画(TimelineView+MeshGradient)

## APP 界面展示

<div align="center">   <img src="https://github.com/user-attachments/assets/f105c8ab-ed36-49a3-b146-11d8d9b9ff14" width="400" />   <img src="https://github.com/user-attachments/assets/5bbe0bfb-b72c-4cf9-adcd-3b3c389cdcee" width="400" /> </div> <div align="center">   <img src="https://github.com/user-attachments/assets/9a7a7507-486a-440f-b048-eb8491a9b810" width="400" />   <img src="https://github.com/user-attachments/assets/7ff380a5-c4f0-446c-a357-b03fd3f3875c" width="400" /> </div>

## 技术实现

- **SwiftUI**: 原生 UI 构建，流畅的交互体验
- **AVFoundation**: 精确的音频处理与同步控制
- **WWDC 新 API**: 采用最新框架提升性能与用户体验
- **自定义组件**: 多个独立开发的可复用 UI 组件

## 使用说明

1. 调整 BPM 值到所需节拍速度
2. 选择合适的音效并调整音量
3. 按下播放按钮开始节拍
4. 支持后台继续工作

## 未来规划

- 增强与其他音乐创作工具的集成能力
- 支持更多节拍模式与自定义选项
- 小组件、动态显示功能
- 文案本地化集中处理
- 添加新功能后准备上架 App Store，现被 Guideline 4.3(a) - Design - Spam 拒绝上架

## 许可证

该项目采用 [MIT 许可证](https://github.com/Weixi779/EchoPulse/blob/main/LICENSE)。

## 联系方式

如有问题或建议，请联系：[sunshiwei418@126.com]
