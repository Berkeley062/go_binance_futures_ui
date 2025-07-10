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
        <el-form-item :label="$t('trade.name')" prop="name" :rules="[{ required: true, message: $t('table.nameRequired'), trigger: 'blur' }]">
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
        <!-- ==== 新增 MACD tab ==== -->
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
            <el-table-column :label="$t('technology.name')" align="center">
              <template slot-scope="scope">
                <el-input v-model="scope.row.name" class="edit-input" size="small" />
              </template>
            </el-table-column>
            <el-table-column :label="$t('technology.klineInterval')" align="center" width="100">
              <template slot-scope="scope">
                <el-select v-model="scope.row.kline_interval" size="small">
                  <el-option v-for="item in klineInterval" :key="item" :label="item" :value="item" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column :label="$t('technology.fast_period')" align="center" width="100">
              <template slot-scope="scope">
                <el-input v-model="scope.row.fast_period" type="number" class="edit-input" size="small" />
              </template>
            </el-table-column>
            <el-table-column :label="$t('technology.slow_period')" align="center" width="100">
              <template slot-scope="scope">
                <el-input v-model="scope.row.slow_period" type="number" class="edit-input" size="small" />
              </template>
            </el-table-column>
            <el-table-column :label="$t('technology.signal_period')" align="center" width="100">
              <template slot-scope="scope">
                <el-input v-model="scope.row.signal_period" type="number" class="edit-input" size="small" />
              </template>
            </el-table-column>
            <el-table-column :label="$t('technology.enable')" align="center" width="100">
              <template slot-scope="scope">
                <el-switch v-model="scope.row.enable" active-color="#13ce66" inactive-color="#dcdfe6" />
              </template>
            </el-table-column>
            <el-table-column :label="$t('table.actions')" align="center" width="100" class-name="small-padding fixed-width">
              <template slot-scope="scope">
                <el-button type="danger" size="mini" @click="delMacd(scope)">
                  {{ $t('table.delete') }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <!-- ==== /新增 MACD tab ==== -->
      </el-tabs>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogTechnologyVisible = false">{{ $t('table.cancel') }}</el-button>
        <el-button type="primary" :loading="dialogLoading" @click="confirmTechnology()">{{ $t('table.confirm') }}</el-button>
      </div>
    </el-dialog>
    <!-- 策略方法 -->
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
        <el-table-column
          :label="$t('strategy.name')"
          align="center"
          width="300"
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
          :label="$t('strategy.code')"
          align="center"
        >
          <template slot-scope="scope">
            <el-input
              v-model="scope.row.code"
              type="textarea"
              :rows="6"
              size="small"
              class="edit-input"
            />
          </template>
        </el-table-column>
        <el-table-column
          :label="$t('strategy.fullScreen')"
          align="center"
          width="100"
        >
          <template slot-scope="scope">
            <el-switch
              v-model="scope.row.fullScreen"
              active-color="#13ce66"
              inactive-color="#dcdfe6"
              @change="fullCodeScreenChange(scope.row, scope.$index)"
            />
          </template>
        </el-table-column>
        <el-table-column
          :label="$t('strategy.type')"
          align="center"
          width="140"
        >
          <template slot-scope="scope">
            <el-select v-model="scope.row.type" size="small">
              <el-option :label="$t('trade.long')" value="long" />
              <el-option :label="$t('trade.short')" value="short" />
              <el-option :label="$t('trade.close_long')" value="close_long" />
              <el-option :label="$t('trade.close_short')" value="close_short" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column
          :label="$t('strategy.enable')"
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
              @click="delStrategy(scope)"
            >{{ $t('table.delete') }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogStrategyVisible = false">{{ $t('table.cancel') }}</el-button>
        <el-button type="primary" :loading="dialogLoading" @click="confirmStrategy()">{{ $t('table.confirm') }}</el-button>
      </div>
    </el-dialog>
    <!-- coding -->
    <el-dialog :title="dialogCodeTitle" :visible.sync="dialogCodeVisible" fullscreen @closed="codeScreenClose">
      <div class="code-full" style="width: 100%;">
        <div style="margin-bottom: 10px; display: flex;justify-content: space-between;align-items: center;">
          <div
            style="display: flex;flex-flow: row wrap;gap: 10px; width:75%"
          >
            <el-link href="https://expr-lang.org/docs/language-definition" type="success" target="_blank">code rule</el-link>
          </div>
          <el-button
            type="primary"
            @click="testStrategyRule"
          >{{ $t('table.test') }}
          </el-button>
        </div>
        <codemirror
          ref="cmEditor"
          :value="code"
          :options="cmOptions"
          @ready="onCmReady"
          @focus="onCmFocus"
          @input="onCmCodeChange"
        />
      </div>
    </el-dialog>
  </div>
</template>

<style lang="scss">
.code-full .CodeMirror.cm-s-monokai.CodeMirror-wrap {
  min-height: 600px;
}
// 补全弹层
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
import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/javascript/javascript.js'
import 'codemirror/mode/go/go.js'
import 'codemirror/addon/selection/active-line'
import 'codemirror/keymap/sublime'
import 'codemirror/mode/css/css'
import 'codemirror/theme/monokai.css'
import 'codemirror/theme/base16-dark.css'
import 'codemirror/addon/scroll/annotatescrollbar.js'
import 'codemirror/addon/search/matchesonscrollbar.js'
import 'codemirror/addon/search/match-highlighter.js'
import 'codemirror/addon/search/jump-to-line.js'
import 'codemirror/addon/dialog/dialog.js'
import 'codemirror/addon/dialog/dialog.css'
import 'codemirror/addon/search/searchcursor.js'
import 'codemirror/addon/search/search.js'
import 'codemirror/addon/fold/foldgutter.css'
import 'codemirror/addon/fold/foldcode'
import 'codemirror/addon/fold/foldgutter'
import 'codemirror/addon/fold/brace-fold'
import 'codemirror/addon/fold/comment-fold'
import 'codemirror/addon/edit/matchbrackets'
import 'codemirror/addon/edit/closebrackets'
import 'codemirror/addon/hint/show-hint.css'
import 'codemirror/addon/hint/show-hint.js'
import 'codemirror/addon/hint/javascript-hint.js'
import 'codemirror/addon/hint/anyword-hint.js'

const initTechnology = {
  ma: [],
  ema: [],
  rsi: [],
  kc: [],
  boll: [],
  atr: [],
  macd: [], // 新增 macd
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

      list: [],
      listLoading: false,
      dialogFormVisible: false,
      dialogLoading: false,
      dialogTitle: 'add template',
      info: {},
      rowKey(row) {
        return row.id
      },
      expandKeys: [],

      dialogTechnologyTitle: '',
      dialogTechnologyVisible: false,
      technologySymbolId: 0,
      technology: JSON.parse(JSON.stringify(initTechnology)),

      dialogStrategyTitle: '',
      dialogStrategyVisible: false,
      strategySymbolId: 0,
      strategy: [],

      code: '',
      cmOptions: {
        tabSize: 2,
        mode: 'text/x-go',
        theme: 'monokai',
        lineNumbers: true,
        line: true,
        foldGutter: true,
        lineWrapping: true,
        autoFormatJson: true,
        jsonIndentation: true,
        gutters: [
          'CodeMirror-linenumbers',
          'CodeMirror-foldgutter',
          'CodeMirror-lint-markers',
        ],
        extraKeys: { 'Tab': 'autocomplete' },
        hintOptions: {
          completeSingle: false, // 当只有一个补全项时，不自动补全
        },
      },
      dialogCodeTitle: '',
      dialogCodeVisible: false,
      strategyIndex: undefined,
    }
  },
  async created() {
    await this.fetchData()
  },
  methods: {
  async addData(info) {
    try {
      await this.$refs.dataForm.validate()
      this.dialogLoading = true;
      await addData(info); // 调用 api 的 addData
      this.$message({ message: this.$t('table.actionSuccess'), type: 'success' });
      this.dialogFormVisible = false;
      await this.fetchData();
    } catch (e) {
      if (e !== false) { // 表单验证失败时 e 为 false
        this.$message({ message: this.$t('table.actionFail'), type: 'error' });
      }
    } finally {
      this.dialogLoading = false;
    }
  },
    openDialog() {
  this.dialogTitle = this.$t('table.add')
  this.dialogFormVisible = true
  this.info = {}
  this.$nextTick(() => {
    this.$refs.dataForm && this.$refs.dataForm.clearValidate()
  })
},
openTechnologyDialog(row) {
  this.technologySymbolId = row.id
  this.dialogTechnologyTitle = `${row.name} ${this.$t('trade.technology')}`
  if (row.technology && row.technology.trim() !== '') {
    try {
      const parsedTechnology = JSON.parse(row.technology)
      this.technology = {
        ...JSON.parse(JSON.stringify(initTechnology)),
        ...parsedTechnology,
      }
    } catch (error) {
      console.warn('解析技术指标数据失败:', error)
      this.technology = JSON.parse(JSON.stringify(initTechnology))
    }
  } else {
    this.technology = JSON.parse(JSON.stringify(initTechnology))
  }
  this.dialogTechnologyVisible = true
},
openStrategyDialog(row) {
  this.strategySymbolId = row.id
  this.dialogStrategyTitle = `${row.name} ${this.$t('trade.strategy')}`
  if (row.strategy && row.strategy.trim() !== '') {
    try {
      this.strategy = JSON.parse(row.strategy)
    } catch (error) {
      console.warn('解析策略数据失败:', error)
      this.strategy = []
    }
  } else {
    this.strategy = []
  }
  this.dialogStrategyVisible = true
},
    async fetchData() {
      this.listLoading = true;
      try {
        const { data } = await getList();
        this.list = data || [];
        console.log('获取策略模板列表成功:', this.list);
      } catch (e) {
        console.error('获取策略模板列表失败:', e);
        this.$message({ message: this.$t('table.actionFail'), type: 'error' });
        this.list = [];
      } finally {
        this.listLoading = false;
      }
    },
    addMacd() {
      this.technology.macd.push({
        name: '',
        kline_interval: '',
        fast_period: 12,
        slow_period: 26,
        signal_period: 9,
        enable: false,
      })
    },
    delMacd(scope) {
      this.technology.macd.splice(scope.$index, 1)
    },
    async confirmTechnology() {
      try {
        // 数据验证和转换
        Object.keys(this.technology).forEach(key => {
          if (Array.isArray(this.technology[key])) {
            this.technology[key].forEach(item => {
              if (item.period) {
                item.period = Number(item.period) || 0
              }
              if (item.multiplier) {
                item.multiplier = Number(item.multiplier) || 0
              }
              if (item.std_dev_multiplier) {
                item.std_dev_multiplier = Number(item.std_dev_multiplier) || 0
              }
              if (item.fast_period) {
                item.fast_period = Number(item.fast_period) || 0
              }
              if (item.slow_period) {
                item.slow_period = Number(item.slow_period) || 0
              }
              if (item.signal_period) {
                item.signal_period = Number(item.signal_period) || 0
              }
            })
          }
        })
        
        const technologyData = JSON.stringify(this.technology)
        console.log('保存技术指标数据:', technologyData)
        
        await editData(this.technologySymbolId, { technology: technologyData })
        this.$message({ message: this.$t('table.actionSuccess'), type: 'success' })
        await this.fetchData()
      } catch (e) {
        console.error('保存技术指标失败:', e)
        this.$message({ message: this.$t('table.actionFail'), type: 'error' })
      }
    },
    async confirmStrategy() {
      try {
        const strategyData = JSON.stringify(this.strategy)
        console.log('保存策略数据:', strategyData)
        
        await editData(this.strategySymbolId, { strategy: strategyData })
        this.$message({ message: this.$t('table.actionSuccess'), type: 'success' })
        await this.fetchData()
      } catch (e) {
        console.error('保存策略失败:', e)
        this.$message({ message: this.$t('table.actionFail'), type: 'error' })
      }
    },
    addMa() {
      this.technology.ma = [
        ...this.technology.ma,
        {
          name: '',
          kline_interval: '',
          period: 14,
          enable: false,
        },
      ]
    },
    delMa(scope) {
      this.technology.ma = this.technology.ma.filter((item, index) => index !== scope.$index)
    },
    addEma() {
      this.technology.ema = [
        ...this.technology.ema,
        {
          name: '',
          kline_interval: '',
          period: 14,
          enable: false,
        },
      ]
    },
    delEma(scope) {
      this.technology.ema = this.technology.ema.filter((item, index) => index !== scope.$index)
    },
    addRsi() {
      this.technology.rsi = [
        ...this.technology.rsi,
        {
          name: '',
          kline_interval: '',
          period: 14,
          enable: false,
        },
      ]
    },
    delRsi(scope) {
      this.technology.rsi = this.technology.rsi.filter((item, index) => index !== scope.$index)
    },
    addKc() {
      this.technology.kc = [
        ...this.technology.kc,
        {
          name: '',
          kline_interval: '',
          period: 50,
          multiplier: 2.75,
          enable: false,
        },
      ]
    },
    delKc(scope) {
      this.technology.kc = this.technology.kc.filter((item, index) => index !== scope.$index)
    },
    addBoll() {
      this.technology.boll = [
        ...this.technology.boll,
        {
          name: '',
          kline_interval: '',
          period: 21,
          std_dev_multiplier: 2,
          enable: false,
        },
      ]
    },
    delBoll(scope) {
      this.technology.boll = this.technology.boll.filter((item, index) => index !== scope.$index)
    },
    addAtr() {
      this.technology.atr = [
        ...this.technology.atr,
        {
          name: '',
          kline_interval: '',
          period: 14,
          enable: false,
        },
      ]
    },
    delAtr(scope) {
      this.technology.atr = this.technology.atr.filter((item, index) => index !== scope.$index)
    },

    addStrategy() {
      this.strategy = [
        ...this.strategy,
        {
          name: '',
          type: '',
          code: '',
          fullScreen: false,
          enable: false,
        },
      ]
    },
    delStrategy(scope) {
      this.strategy = this.strategy.filter((item, index) => index !== scope.$index)
    },
    fullCodeScreenChange(row, index) {
      this.strategyIndex = index
      this.code = row.code
      this.dialogCodeTitle = `${row.name} ${this.$t('strategy.code')}`
      this.dialogCodeVisible = true
    },
    onCmReady(cm) {
      this.cm = cm
      // 设置自定义提示功能
      cm.on('keyup', (cm, event) => {
        if (!cm.state.completionActive && event.keyCode !== 13 && event.keyCode !== 27) {
          CodeMirror.commands.autocomplete(cm, null, { completeSingle: false })
        }
      })
    },
    onCmFocus(cm) {
      // 处理焦点事件
    },
    onCmCodeChange(newCode) {
      this.code = newCode
      if (this.strategyIndex !== undefined) {
        this.strategy[this.strategyIndex].code = newCode
      }
    },
    codeScreenClose() {
      this.strategyIndex = undefined
      this.code = ''
    },
    customHint(cm) {
      const cursor = cm.getCursor()
      const token = cm.getTokenAt(cursor)
      const line = cm.getLine(cursor.line)
      
      const list = [
        'price', 'volume', 'open', 'high', 'low', 'close',
        'ma', 'ema', 'rsi', 'kc', 'boll', 'atr', 'macd',
        'if', 'else', 'for', 'while', 'return', 'true', 'false',
        'buy', 'sell', 'close_position'
      ]
      
      return {
        list: list.filter(item => item.toLowerCase().includes(token.string.toLowerCase())),
        from: CodeMirror.Pos(cursor.line, token.start),
        to: CodeMirror.Pos(cursor.line, token.end)
      }
    },
    async testStrategyRule() {
      try {
        // 需要提供symbol参数，这里使用当前策略模板的ID作为symbol
        const symbol = this.strategySymbolId || 'default'
        const res = await testStrategyRule(symbol, { code: this.code })
        
        if (res.code === 200) {
          // 检查返回结果中的pass字段
          const result = res?.data?.pass
          if (typeof result === 'boolean') {
            const message = result ? '策略验证通过' : '策略验证失败'
            const type = result ? 'success' : 'warning'
            this.$message({ message: message, type: type })
          } else {
            // 如果没有pass字段，显示原始结果
            this.$message({ message: `验证结果: ${JSON.stringify(res.data)}`, type: 'success' })
          }
        } else {
          this.$message({ message: `验证失败: ${res.message || '未知错误'}`, type: 'error' })
        }
      } catch (e) {
        console.error('策略验证失败:', e)
        this.$message({ message: this.$t('table.actionFail'), type: 'error' })
      }
    },
    async del(row) {
      try {
        await this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
          confirmButtonText: this.$t('table.confirm'),
          cancelButtonText: this.$t('table.cancel'),
          type: 'warning'
        })
        await delData(row.id)
        this.$message({ message: this.$t('table.deleteSuccess'), type: 'success' })
        await this.fetchData()
      } catch (e) {
        if (e !== 'cancel') {
          this.$message({ message: this.$t('table.deleteFail'), type: 'error' })
        }
      }
    },
  },
}
</script>
