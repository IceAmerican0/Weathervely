//
//  AlertManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit

public final class AlertManager {
    public static let shared = AlertManager()
    
    private init() {
        configureNotificationHapticGenerator()
        configureSelectionHapticGenerator()
        configureImpactHapticGenerator()
    }
    
    private var commonAlert = AlertAction(windowLevel: .statusBar)
    
    private var notificationHapticGenerator: UINotificationFeedbackGenerator?
    private var impactHapticFeedbackGenerator: UIImpactFeedbackGenerator?
    private var selectionHapticGenerator: UISelectionFeedbackGenerator?
    
    public func present(contents: AlertViewState) {
        hapticTypeMapper(type: contents.hapticType)
        commonAlert.present(contents: contents)
    }
    
    public func dismiss(completion: AlertActionHandler?) {
        commonAlert.dismiss(completion: completion)
    }
    
    private func configureNotificationHapticGenerator() {
        notificationHapticGenerator = UINotificationFeedbackGenerator()
        notificationHapticGenerator?.prepare()
    }
    
    private func configureSelectionHapticGenerator() {
        selectionHapticGenerator = UISelectionFeedbackGenerator()
        selectionHapticGenerator?.prepare()
    }
    
    private func configureImpactHapticGenerator() {
        impactHapticFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactHapticFeedbackGenerator?.prepare()
    }
    
    private func hapticTypeMapper(type: AlertViewState.HapticType) {
        switch type {
        case .success:
            notificationHapticGenerator?.notificationOccurred(.success)
        case .error:
            notificationHapticGenerator?.notificationOccurred(.error)
        case .warning:
            notificationHapticGenerator?.notificationOccurred(.warning)
        case .select:
            selectionHapticGenerator?.selectionChanged()
        case .impact:
            impactHapticFeedbackGenerator?.impactOccurred()
        }
    }
}
