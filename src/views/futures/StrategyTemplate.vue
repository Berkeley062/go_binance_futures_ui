<template>
  <div class="app-container">
    <div style="margin-bottom: 10px">
      <el-button
        type="success"
        size="mini"
        @click="openDialog()"
      >
        {{ $t('table.add') }}
      </el-button>
      <el-button
        type="primary"
        size="mini"
        :loading="listLoading"
        @click="fetchData()"
      >
        {{ $t('table.refresh') }}
      </el-button>
    </div>
    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="Loading"
      border
      fit
      size="mini"
      :row-key="rowKey"
      :expand-row-keys="expandKeys"
      highlight-current-row
    >
      <el-table-column
        :label="$t('trade.name')"
        align="center"
        show-overflow-tooltip
      >
        <template slot-scope="scope">
          {{ scope.row.name }}
        </template>
      </el-table-column>
      <el-table-column
        :label="$t('trade.technology')"
        align="center"
        width="120"
      >
        <template slot-scope="scope">
          <el-button
            type="success"
            size="mini"
            @click="openTechnologyDialog(scope.row)"
          > {{ $t('trade.technology') }}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column
        :label="$t('trade.strategy')"
        align="center"
        width="100"
      >
        <template slot-scope="scope">
          <el-button
            type="success"
            size="mini"
            @click="openStrategyDialog(scope.row)"
          > {{ $t('trade.strategy') }}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column
        :label="$t('table.actions')"
        align="center"
        width="80"
        class-name="small-padding fixed-width"
      >
        <template slot-scope="{row}">
          <el-button
            type="danger"
            size="mini"
            @click="del(row)"
          >{{ $t('table.delete') }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 新增 coin -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogFormVisible">
      <el-form
        ref="dataForm"
        :model="info"
        label-position="left"
        label-width="100px"
        style="width: 400px; margin-left:50px;"
      >
        <el-form-item :label="$t('trade.name')" prop="name">
          <el-input v-model="info.name" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">{{ $t('table.cancel') }}</el-button>
        <el-button type="primary" :loading="dialogLoading" @click="addData(info)">{{ $t('table.confirm') }}</el-button>
      </div>
    </el-dialog>
    <!-- 技术指标 -->
    <el-dialog :title="dialogTechnologyTitle" :visible.sync="dialogTechnologyVisible">
      <el-tabs value="ma">
        <el-tab-pane label="ma" name="ma">
          <div>
            <el-button type="primary" @click="addMa">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.ma"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.period"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delMa(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="ema" name="ema">
          <div>
            <el-button type="primary" @click="addEma">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.ema"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.period"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delEma(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="rsi" name="rsi">
          <div>
            <el-button type="primary" @click="addRsi">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.rsi"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.period"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delRsi(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="kc" name="kc">
          <div>
            <el-button type="primary" @click="addKc">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.kc"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.period"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.multiplier')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.multiplier"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delKc(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="boll" name="boll">
          <div>
            <el-button type="primary" @click="addBoll">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.boll"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.period"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.std_dev_multiplier')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.std_dev_multiplier"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delBoll(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="atr" name="atr">
          <div>
            <el-button type="primary" @click="addAtr">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.atr"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.period"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delAtr(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <!-- MACD 技术指标配置 -->
        <el-tab-pane label="macd" name="macd">
          <div>
            <el-button type="primary" @click="addMacd">{{ $t('table.add') }}</el-button>
          </div>
          <el-table
            :data="technology.macd"
            border
            fit
            size="mini"
            highlight-current-row
            style="margin-top: 10px"
          >
            <el-table-column
              :label="$t('technology.name')"
              align="center"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.name"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.klineInterval')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.fast_period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.fast_period"
                  type="number"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.slow_period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.slow_period"
                  type="number"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.signal_period')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-input
                  v-model="scope.row.signal_period"
                  type="number"
                  class="edit-input"
                  size="small"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('technology.enable')"
              align="center"
              width="100"
            >
              <template slot-scope="scope">
                <el-switch
                  v-model="scope.row.enable"
                  active-color="#13ce66"
                  inactive-color="#dcdfe6"
                />
              </template>
            </el-table-column>
            <el-table-column
              :label="$t('table.actions')"
              align="center"
              width="100"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="delMacd(scope)"
                >{{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogTechnologyVisible = false">{{ $t('table.cancel') }}</el-button>
        <el-button type="primary" :loading="dialogLoading" @click="confirmTechnology()">{{ $t('table.confirm') }}</el-button>
      </div>
    </el-dialog>
    <!-- 策略方法 ... 省略代码 ... -->
    <!-- 保持原有内容 -->
    <el-dialog :title="dialogStrategyTitle" :visible.sync="dialogStrategyVisible" width="75%">
      <div>
        <el-button type="primary" @click="addStrategy">{{ $t('table.add') }}</el-button>
      </div>
      <el-table
        :data="strategy"
        border
        fit
        size="mini"
        highlight-current-row
        style="margin-top: 10px"
      >
        <!-- ...策略表格代码同原有... -->
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogStrategyVisible = false">{{ $t('table.cancel') }}</el-button>
        <el-button type="primary" :loading="dialogLoading" @click="confirmStrategy()">{{ $t('table.confirm') }}</el-button>
      </div>
    </el-dialog>
    <!-- coding ... 保持原有内容 ... -->
    <el-dialog :title="dialogCodeTitle" :visible.sync="dialogCodeVisible" fullscreen @closed="codeScreenClose">
      <div class="code-full" style="width: 100%;">
        <!-- ...保持原有内容... -->
      </div>
    </el-dialog>
  </div>
</template>

<style lang="scss">
.code-full .CodeMirror.cm-s-monokai.CodeMirror-wrap {
  min-height: 600px;
}
.CodeMirror-hints {
  z-index: 9999;
}
</style>

<script>
import { getList, editData, addData, delData, testStrategyRule } from '@/api/strategy_template'
import { round } from 'mathjs'
import { parseTime } from '@/utils'

import CodeMirror from 'codemirror'
import { codemirror } from 'vue-codemirror'
// ...（省略其余 import，保持原有不变）

const initTechnology = {
  ma: [],
  ema: [],
  rsi: [],
  kc: [],
  boll: [],
  atr: [],
  macd: [], // 新增MACD
}

export default {
  components: {
    codemirror,
  },
  data() {
    return {
      klineInterval: [
        '1m', '3m', '5m', '15m', '30m', '1h', '2h', '4h', '6h', '8h', '12h', '1d', '3d', '1w', '1M',
      ],
      // ...（其余data保持原有）
      technology: JSON.parse(JSON.stringify(initTechnology)),
      // ...（其余data保持原有）
    }
  },
  async created() {
    await this.fetchData()
  },
  methods: {
    // ... 其余methods 保持原有
    addMacd() {
      this.technology.macd = [
        ...this.technology.macd,
        {
          name: '',
          kline_interval: '',
          fast_period: 12,
          slow_period: 26,
          signal_period: 9,
          enable: false,
        },
      ]
    },
    delMacd(scope) {
      this.technology.macd = this.technology.macd.filter((item, index) => index !== scope.$index)
    },
    confirmTechnology() {
      try {
        Object.keys(this.technology).forEach(key => {
          this.technology[key].forEach(item => {
            // MACD 参数转为数字类型
            if (item.fast_period !== undefined) item.fast_period = Number(item.fast_period)
            if (item.slow_period !== undefined) item.slow_period = Number(item.slow_period)
            if (item.signal_period !== undefined) item.signal_period = Number(item.signal_period)
            // 其他指标参数处理...
          })
        })
        // ...后续API调用...
      } catch (e) {
        // 错误处理
      }
    },
    // ... 其余methods 保持原有
  }
}
</script>
