//
//  FlowHStack.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/9.
//

import SwiftUI

struct FlowHStack: Layout {
    var hSpacing: CGFloat = 8
    var vSpacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        var maxIdealWidth = CGFloat.zero
        var maxIdealHeight = CGFloat.zero
        var idealWidthSum = CGFloat.zero
        var idealHeightSum = CGFloat.zero
        
        subviews.forEach { subview in
            let idealSize = subview.sizeThatFits(.unspecified)
            maxIdealWidth = max(maxIdealWidth, idealSize.width)
            maxIdealHeight = max(maxIdealHeight, idealSize.height)
            idealWidthSum += idealSize.width
            idealHeightSum += idealSize.height
        }
        
        if proposal.width == .zero {
            return CGSize(width: maxIdealWidth, height: (idealHeightSum + vSpacing * CGFloat(subviews.count - 1)))
        } else if proposal.width == nil || proposal.width == .infinity {
            return CGSize(width: (idealWidthSum + hSpacing * CGFloat(subviews.count - 1)), height: maxIdealHeight)
        } else {
            // 给定宽度，计算高度。宽度不够时使用单列布局。
            var first = true
            var lineHeight = CGFloat.zero
            var result = CGSize.zero
            result.width = max(proposal.width!, maxIdealWidth)
            /// 剩余空间，包括间距
            var widthRemaining = result.width
            subviews.forEach { subview in
                let idealSize = subview.sizeThatFits(.unspecified)
                if first {
                    first = false
                    lineHeight = idealSize.height
                    widthRemaining = result.width - idealSize.width
                } else {
                    if widthRemaining < (idealSize.width + hSpacing) {
                        // 换行
                        result.height += lineHeight
                        result.height += vSpacing
                        lineHeight = idealSize.height
                        widthRemaining = result.width - idealSize.width
                    } else {
                        lineHeight = max(lineHeight, idealSize.height)
                        widthRemaining -= hSpacing
                        widthRemaining -= idealSize.width
                    }
                }
            }
            result.height += lineHeight
            return result
        }
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var point = bounds.origin
        var first = true
        var lineHeight = CGFloat.zero
        subviews.forEach { subview in
            let dimension = subview.dimensions(in: .unspecified)
            if first {
                first = false
                subview.place(at: point, proposal: .unspecified)
                point.x += dimension.width
                lineHeight = max(lineHeight, dimension.height)
            } else {
                if (bounds.width - point.x) < (dimension.width + hSpacing) {
                    // 换行
                    point.y += lineHeight
                    point.y += vSpacing
                    point.x = bounds.origin.x
                    subview.place(at: point, proposal: .unspecified)
                    lineHeight = dimension.height
                    point.x += dimension.width
                } else {
                    point.x += hSpacing
                    subview.place(at: point, proposal: .unspecified)
                    lineHeight = max(lineHeight, dimension.height)
                    point.x += dimension.width
                }
            }
        }
    }
}
