export enum MineMenuIconKey {
    HEALTH_SETTINGS = "healthSettings",
    DATA_MANAGEMENT = "dataManagement",
    DEVICE_MANAGEMENT = "deviceManagement",
    PRIVACY = "privacy",
    HELP = "help",
    ABOUT = "about"
}
export enum MineDetailRoute {
    NONE = "none",
    PROFILE = "profile",
    HEALTH_SETTINGS = "healthSettings",
    DATA_MANAGEMENT = "dataManagement",
    DEVICE_MANAGEMENT = "deviceManagement",
    PRIVACY = "privacy",
    HELP = "help",
    ABOUT = "about"
}
export interface MineMenuItem {
    label: string;
    iconKey: MineMenuIconKey;
    route: MineDetailRoute;
}
export interface MineMenuGroup {
    items: MineMenuItem[];
}
export function createMineMenuGroups(): MineMenuGroup[] {
    return [
        {
            items: [
                {
                    label: '健康设置',
                    iconKey: MineMenuIconKey.HEALTH_SETTINGS,
                    route: MineDetailRoute.HEALTH_SETTINGS
                },
                {
                    label: '数据管理',
                    iconKey: MineMenuIconKey.DATA_MANAGEMENT,
                    route: MineDetailRoute.DATA_MANAGEMENT
                },
                {
                    label: '设备管理',
                    iconKey: MineMenuIconKey.DEVICE_MANAGEMENT,
                    route: MineDetailRoute.DEVICE_MANAGEMENT
                },
                {
                    label: '系统与隐私',
                    iconKey: MineMenuIconKey.PRIVACY,
                    route: MineDetailRoute.PRIVACY
                }
            ]
        },
        {
            items: [
                { label: '帮助与反馈', iconKey: MineMenuIconKey.HELP, route: MineDetailRoute.HELP },
                { label: '关于我们', iconKey: MineMenuIconKey.ABOUT, route: MineDetailRoute.ABOUT }
            ]
        }
    ];
}
export function getMineDetailTitle(route: MineDetailRoute): string {
    switch (route) {
        case MineDetailRoute.PROFILE:
            return '个人资料';
        case MineDetailRoute.HEALTH_SETTINGS:
            return '健康设置';
        case MineDetailRoute.DATA_MANAGEMENT:
            return '数据管理';
        case MineDetailRoute.DEVICE_MANAGEMENT:
            return '设备管理';
        case MineDetailRoute.PRIVACY:
            return '系统与隐私';
        case MineDetailRoute.HELP:
            return '帮助与反馈';
        case MineDetailRoute.ABOUT:
            return '关于我们';
        case MineDetailRoute.NONE:
        default:
            return '';
    }
}
