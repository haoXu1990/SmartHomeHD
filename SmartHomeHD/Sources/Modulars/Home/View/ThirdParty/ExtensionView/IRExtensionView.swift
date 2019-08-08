//
//  IRExtensionView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/7.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import NSObject_Rx
import RxCocoa
import ReusableKit

class IRExtensionView: UIView, View {
    var disposeBag: DisposeBag = DisposeBag.init()
    
    var backgroundImage: UIImageView!
    var titleLabel: UILabel!
    var contentView: UIView!
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        backgroundImage = UIImageView.init()
        backgroundImage.image = UIImage.init(named: "image_virtual_control_bg")
        self.addSubview(backgroundImage)
        
        titleLabel = UILabel.init()
        titleLabel.font = SMART_HOME_TITLE_FONT
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "扩展按键"
        self.addSubview(titleLabel)

        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 100, height: 100)
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.extensionCell)
        self.addSubview(collectionView)
        
        
        
      
    }
    
    override func layoutSubviews() {
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImage.snp.top).offset(10)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.left.right.equalTo(backgroundImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension IRExtensionView {
 
    func bind(reactor: IRExtensionViewReactor) {
       
        
        reactor.state.map { $0.extensionKeys }
            .bind(to: collectionView.rx.items) { (cv, ip, model) in
                
                let indexPath = IndexPath.init(row: ip, section: 0)
                let cell = cv.dequeue(Reusable.extensionCell, for: indexPath)
                
                cell.btn.setTitle(self.fetchKeyName(key: model), for: .normal)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.modelSelected(TJIrKey.self)
            .subscribe(onNext: { [weak self](irKey) in
                guard let self = self else  {return}
                
                // 空调
                if reactor.deviceModel.typeid == "7" {
                    Observable.just(Reactor.Action.sendAirCommand(irKey, 0))
                        .bind(to: self.reactor!.action)
                        .disposed(by: self.rx.disposeBag)
                }
                else {
                    self.sendObsver(keType: irKey.type)
                    
                }
                
            
        }).disposed(by: rx.disposeBag)
    }
    
    
    func sendObsver(keType: IRKeyType) {
        
        Observable.just(Reactor.Action.sendCommond(keType))
            .bind(to: self.reactor!.action)
            .disposed(by: rx.disposeBag)
    }
    
    
    
}

extension IRExtensionView {
    
    func fetchKeyName(key: TJIrKey) -> String {
        
        var name = ""
        if let tmp = key.name, tmp != ""{ return tmp}
        switch (key.type.rawValue) {
        case -100:
            name = "自定义键-圆形";
            break;
        case -99:
            name = "自定义键-椭圆";
            break;
        case -98:
            name = "自定义键-方形";
            break;
        case -97:
            name = "自定义键-红色";
            break;
        case -96:
            name = "自定义键-橙色";
            break;
        case -95:
            name = "自定义键-黄色";
            break;
        case -94:
            name = "自定义键-绿色";
            break;
        case -93:
            name = "自定义键-蓝色";
            break;
        case -92:
            name = "自定义键-青色";
            break;
        case -91:
            name = "自定义键-紫色";
            break;
        case -90:
            name = "记忆键";
            break;
        case 0:
            name = "0";
            break;
        case 1:
            name = "1";
            break;
        case 2:
            name = "2";
            break;
        case 3:
            name = "3";
            break;
        case 4:
            name = "4";
            break;
        case 5:
            name = "5";
            break;
        case 6:
            name = "6";
            break;
        case 7:
            name = "7";
            break;
        case 8:
            name = "8";
            break;
        case 9:
            name = "9";
            break;
        case 800:
            name = "电源";
            break;
        case 801:
            name = "信源键";
            break;
        case 802:
            name = "信息显示";
            break;
        case 803:
            name = "回看";
            break;
        case 804:
            name = "静音";
            break;
        case 805:
            name = "数位";
            break;
        case 806:
            name = "返回";
            break;
        case 807:
            name = "频道+";
            break;
        case 808:
            name = "频道-";
            break;
        case 809:
            name = "音量+";
            break;
        case 810:
            name = "音量-";
            break;
        case 811:
            name = "温度加";
            break;
        case 812:
            name = "温度减";
            break;
        case 813:
            name = "放大";
            break;
        case 814:
            name = "缩小";
            break;
        case 815:
            name = "记忆键1";
            break;
        case 816:
            name = "记忆键2";
            break;
        case 817:
            name = "OK键";
            break;
        case 818:
            name = "上翻";
            break;
        case 819:
            name = "下翻";
            break;
        case 820:
            name = "左翻";
            break;
        case 821:
            name = "右翻";
            break;
        case 822:
            name = "菜单键";
            break;
        case 823:
            name = "退出";
            break;
        case 824:
            name = "前进";
            break;
        case 825:
            name = "后退键";
            break;
        case 826:
            name = "暂停/播放";
            break;
        case 827:
            name = "停止";
            break;
        case 828:
            name = "上一个";
            break;
        case 829:
            name = "下一个";
            break;
        case 830:
            name = "到顶";
            break;
        case 831:
            name = "到底";
            break;
        case 832:
            name = "模式";
            break;
        case 833:
            name = "风量";
            break;
        case 834:
            name = "水平风向";
            break;
        case 835:
            name = "垂直风向";
            break;
        case 836:
            name = "摇头";
            break;
        case 837:
            name = "风类";
            break;
        case 838:
            name = "风速";
            break;
        case 839:
            name = "打开";
            break;
        case 840:
            name = "标题";
            break;
        case 841:
            name = "+10";
            break;
        case 842:
            name = "语言";
            break;
        case 843:
            name = "屏幕";
            break;
        case 844:
            name = "声道";
            break;
        case 845:
            name = "制式";
            break;
        case 846:
            name = "字幕";
            break;
        case 847:
            name = "双画面";
            break;
        case 848:
            name = "画面冻结";
            break;
        case 849:
            name = "重置";
            break;
        case 850:
            name = "视频";
            break;
        case 851:
            name = "慢放";
            break;
        case 852:
            name = "单反主键";
            break;
        case 853:
            name = "单反副键";
            break;
        case 854:
            name = "连续+";
            break;
        case 855:
            name = "连续-";
            break;
        case 856:
            name = "连续右";
            break;
        case 857:
            name = "连续左";
            break;
        case 870:
            name = "风向";
            break;
        case 871:
            name = "灯光";
            break;
        case 872:
            name = "超强";
            break;
        case 873:
            name = "睡眠";
            break;
        case 874:
            name = "换气";
            break;
        case 875:
            name = "干燥";
            break;
        case 876:
            name = "定时";
            break;
        case 877:
            name = "加湿";
            break;
        case 878:
            name = "负离子";
            break;
        case 879:
            name = "节能";
            break;
        case 880:
            name = "舒适";
            break;
        case 881:
            name = "温度显示";
            break;
        case 882:
            name = "一键冷";
            break;
        case 883:
            name = "一键热";
            break;
        case 900:
            name = "自动";
            break;
        case 901:
            name = "信号";
            break;
        case 902:
            name = "灯光";
            break;
        case 903:
            name = "电脑";
            break;
        case 1000:
            name = "冷风";
            break;
        case 1010:
            name = "首页";
            break;
        case 1011:
            name = "设置";
            break;
        case 1012:
            name = "弹出菜单";
            break;
        case 1013:
            name = "顶菜单";
            break;
        case 1800:
            name = "第二电源键";
            break;
        case 2001:
            name = "收藏按钮";
            break;
        case 2002:
            name = "数字按钮";
            break;
        case 2003:
            name = "扩展";
            break;
        default:
            name = "其他";
        }
        return name;
    }
}

private enum Reusable {
    
    
    static let extensionCell = ReusableCell<IRExtensionCell>.init(identifier: "IRExtensionCell1", nib: nil)
}

