# README

## What is NABP
**NABP (NamuICT Automated Baremetal Provisioning)** 는 대규모 HPC / 데이터센터 환경에서 
**베어메탈 서버를 자동으로 프로비저닝**하기 위한 ZTP(Zero Touch Provisioning) 기반 소프트웨어입니다.

## Who should read this
이 매뉴얼은 다음 사용자를 대상으로 합니다:

- **Administrators**
  - 네트워크, OS, PXE, DHCP, BIOS 설정을 담당하는 관리자
- **Operators**
  - 실제 OS 배포 및 상태 모니터링을 수행하는 운영자
- **System Engineers**
  - ZTP 템플릿 및 워크플로우를 설계·확장하는 엔지니어

## Why NABP
NABP는 다음과 같은 환경을 전제로 설계되었습니다:

- 수십 ~ 수천 노드의 동시 OS 배포
- 폐쇄망 또는 제한된 외부 네트워크 환경
- Diskfull / Diskless 서버 혼합 구성
- BIOS, BMC, Redfish, PXE, OS 설치 자동화
- 배포 단계별 상태 및 체크포인트 추적

## Provisioning Workflow Overview
NABP의 OS 배포는 크게 두 단계로 구성됩니다.

### 1. Configuration (Administrator)
- Login
- Subnets
- Installation Media
- Partition
- Provisioning Workflow
- Operating System
- Machine Group

### 2. Operation (Operator)
- ZTP Template 생성
- ZTP Dashboard에서 작업 생성
- Machines 상태 확인

## Scope & Assumptions
이 문서는 다음을 전제로 합니다:

- Linux 기반 서버 환경
- PXE / DHCP / TFTP / HTTP 기본 개념 이해
- BMC (IPMI or Redfish) 접근 가능

본 문서는 하드웨어 벤더별 BIOS 세부 설정 방법은 다루지 않습니다.

## Version Information
- NABP Version: **v3.5.0**
- Document Version: **v1.0**
- Last Updated: 2026-02-09


